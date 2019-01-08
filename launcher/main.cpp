#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <iostream>
#include <memory>
#include <unordered_map>
#include <utility>
#include "app_list.hpp"
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/surface.hpp"
#include "icon.hpp"

#define RESPREFIX "/technology/unrelenting/numbernine/launcher/"

static void select_row_delta(Gtk::ListBox *listbox, int delta) {
	Gtk::ListBoxRow *new_row = nullptr;
	auto *sel_row = listbox->get_selected_row();
	if (sel_row == nullptr) {
		new_row = listbox->get_row_at_index(0);
	} else {
		new_row = listbox->get_row_at_index(sel_row->get_index() + delta);
	}
	if (new_row != nullptr) {
		listbox->select_row(*new_row);
		auto alloc = new_row->get_allocation();
		listbox->get_adjustment()->clamp_page(alloc.get_y(), alloc.get_y() + alloc.get_height());
	}
}

class launcher {
 public:
	app_list applist;
	std::vector<Glib::RefPtr<Gio::DesktopAppInfo>> current_apps;
	Gtk::Box *topl = nullptr;
	Gtk::ListBox *resultbox = nullptr;
	Gtk::SearchEntry *searchbar = nullptr;
	std::shared_ptr<Gtk::Window> window;
	std::optional<sigc::connection> update_timer;

	launcher(std::shared_ptr<Gtk::Window> w) : window(std::move(std::move(w))) {
		Glib::RefPtr<Gtk::Builder> builder =
		    Gtk::Builder::create_from_resource(RESPREFIX "launcher.glade");
		builder->get_widget("toplevel", topl);
		builder->get_widget("resultbox", resultbox);
		builder->get_widget("searchbar", searchbar);
		clear();

		searchbar->signal_changed().connect([&] {
			if (update_timer.has_value()) {
				update_timer->disconnect();
			}
			update_timer = Glib::signal_timeout().connect(
			    [&] {
				    clear();
				    current_apps.clear();
				    for (auto idx : applist.fuzzy_search(searchbar->get_text())) {
					    add_row_for_app(applist.apps[idx]);
					    current_apps.push_back(applist.apps[idx]);
				    }
				    return false;
			    },
			    80);
		});

		searchbar->signal_key_press_event().connect([&](GdkEventKey *evt) {
			if (evt->keyval == GDK_KEY_Tab || evt->keyval == GDK_KEY_KP_Tab ||
			    evt->keyval == GDK_KEY_ISO_Left_Tab) {
				return true;
			} else if (evt->keyval == GDK_KEY_Up || evt->keyval == GDK_KEY_KP_Up) {
				select_row_delta(resultbox, -1);
				return true;
			} else if (evt->keyval == GDK_KEY_Down || evt->keyval == GDK_KEY_KP_Down) {
				select_row_delta(resultbox, 1);
				return true;
			}
		});

		resultbox->signal_row_activated().connect([&](auto &row) {
			std::cerr << "launching " << current_apps[row->get_index()]->get_name() << std::endl;
			std::vector<Glib::RefPtr<Gio::File>> files;
			current_apps[row->get_index()]->launch(files);
			window->hide();
		});

		window->signal_key_release_event().connect([&](GdkEventKey *evt) {
			if (evt->keyval == GDK_KEY_Escape) {
				window->hide();
				return true;
			} else if (evt->keyval == GDK_KEY_Return || evt->keyval == GDK_KEY_KP_Enter) {
				auto *row = resultbox->get_selected_row();
				if (row == nullptr) {
					row = resultbox->get_row_at_index(0);
				}
				if (row != nullptr) {
					row->activate();
					return true;
				}
			}
			return false;
		});

		topl->reference();
		applist.refresh();
	}

	void clear() {
		for (auto &tpl_row : resultbox->get_children()) {
			resultbox->remove(*tpl_row);
			delete tpl_row;
		}
	}

	void add_row_for_app(const Glib::RefPtr<Gio::DesktopAppInfo> &app) {
		Glib::RefPtr<Gtk::Builder> builder =
		    Gtk::Builder::create_from_resource(RESPREFIX "launcher.glade");
		Gtk::Grid *grid = nullptr;
		builder->get_widget("row-double", grid);
		grid->get_parent()->remove(*grid);

		Gtk::Label *title = nullptr, *subtitle = nullptr;
		builder->get_widget("row-double-title", title);
		builder->get_widget("row-double-subtitle", subtitle);

		icon *icon = nullptr;
		builder->get_widget_derived("row-double-icon", icon);

		title->set_text(app->get_name());
		subtitle->set_text(app->get_description());
		icon->set_app(Glib::RefPtr<Gio::AppInfo>::cast_static(app));

		resultbox->insert(*grid, -1);
		grid->reference();
	}
};

std::unique_ptr<lsh::surface> init_lsh(lsh::manager &lsh_mgr, std::shared_ptr<Gtk::Window> window) {
	auto window_lsh =
	    std::make_unique<lsh::surface>(lsh_mgr, window, lsh::any_output, lsh::layer::top);
	window_lsh->set_anchor(lsh::anchor::top | lsh::anchor::left | lsh::anchor::bottom |
	                       lsh::anchor::right);
	window_lsh->set_size(700, 400);
	window_lsh->set_keyboard_interactivity(true);
	return window_lsh;
}

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.launcher");
	lsh::manager lsh_mgr(app);

	auto window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
	window->set_default_size(700, 400);
	window->set_decorated(false);
	window->set_app_paintable(true);
	std::unique_ptr<lsh::surface> window_lsh;

	auto css = Gtk::CssProvider::create();
	css->load_from_resource(RESPREFIX "style.css");
	window->get_style_context()->add_provider_for_screen(Gdk::Screen::get_default(), css,
	                                                     GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

	launcher launcher(window);
	Gtk::EventBox wrapper;

	wrapper.get_style_context()->add_class("n9-launcher-transparent-wrapper");
	wrapper.set_above_child(false);
	wrapper.signal_button_press_event().connect([&](GdkEventButton *b) {
		Gdk::Rectangle click_rect;
		click_rect.set_width(1);
		click_rect.set_height(1);
		click_rect.set_x(b->x_root);
		click_rect.set_y(b->y_root);
		if (!click_rect.intersects(launcher.topl->get_allocation())) {
			window->hide();
		}
		return true;
	});

	launcher.topl->set_valign(Gtk::Align::ALIGN_CENTER);
	launcher.topl->set_halign(Gtk::Align::ALIGN_CENTER);
	launcher.topl->set_hexpand(true);
	launcher.topl->set_size_request(700, 400);

	wrapper.add(*launcher.topl);
	wrapper.show_all();
	window->add(wrapper);

	Glib::RefPtr<Gio::SimpleAction> reveal = Gio::SimpleAction::create("reveal");
	reveal->signal_activate().connect([&](const Glib::VariantBase &param) {
		if (!window->is_visible()) {
			window_lsh = init_lsh(lsh_mgr, window);
			window->show_all();
		}
		launcher.searchbar->grab_focus();
	});
	app->add_action(reveal);

	app->hold();
	return app->run();
}
