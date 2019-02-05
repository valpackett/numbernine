#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <iostream>
#include <memory>
#include <unordered_map>
#include <utility>
#include "app_list.hpp"
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/surface.hpp"
#include "gtk-util/glade.hpp"
#include "gtk-util/icon.hpp"
#include "gtk-util/list_box_reuser.hpp"

#define RESPREFIX "/technology/unrelenting/numbernine/launcher/"

using Glib::RefPtr, Glib::VariantBase;
using std::vector, std::unique_ptr, std::shared_ptr;

static void select_row_delta(Gtk::ListBox *listbox, int delta) {
	Gtk::ListBoxRow *new_row = nullptr;
	auto *sel_row = listbox->get_selected_row();
	if (sel_row == nullptr || !sel_row->is_visible()) {
		new_row = listbox->get_row_at_index(0);
	} else {
		new_row = listbox->get_row_at_index(sel_row->get_index() + delta);
	}
	if (new_row != nullptr && new_row->is_visible()) {
		listbox->select_row(*new_row);
		auto alloc = new_row->get_allocation();
		listbox->get_adjustment()->clamp_page(alloc.get_y(), alloc.get_y() + alloc.get_height());
	}
}

struct app_row {
	RefPtr<Gtk::Builder> builder;
	GLADE(Gtk::Grid, row_dbl_toplevel);
	GLADE(Gtk::Label, row_dbl_title);
	GLADE(Gtk::Label, row_dbl_subtitle);
	GLADE_DERIVED(gutil::icon, row_dbl_icon);

	app_row(RefPtr<Gtk::Builder> &_builder) : builder(_builder) {}

	void on_added() {}

	Gtk::Grid *toplevel() { return row_dbl_toplevel; }
};

struct launcher {
	app_list applist;
	vector<RefPtr<Gio::DesktopAppInfo>> current_apps;
	shared_ptr<Gtk::Window> window;
	std::optional<sigc::connection> update_timer;

	RefPtr<Gtk::Builder> builder = Gtk::Builder::create_from_resource(RESPREFIX "launcher.glade");

	GLADE(Gtk::Box, toplevel);
	GLADE(Gtk::ListBox, resultbox);
	GLADE(Gtk::SearchEntry, searchbar);

	gutil::list_box_reuser<app_row> app_rows{RESPREFIX "launcher.glade", resultbox, true};

	launcher(shared_ptr<Gtk::Window> w) : window(std::move(std::move(w))) {
		clear();

		searchbar->signal_changed().connect([&] {
			if (update_timer.has_value()) {
				update_timer->disconnect();
			}
			update_timer = Glib::signal_timeout().connect(
			    [&] {
				    current_apps.clear();
				    auto results = applist.fuzzy_search(searchbar->get_text());
				    app_rows.ensure_row_count(results.size());
				    size_t i = 0;
				    for (auto idx : results) {
					    set_row_to_app(i++, applist.apps[idx]);
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
			} else if (evt->keyval == GDK_KEY_Escape) {
				window->hide();
				return true;
			}
			return false;
		});

		searchbar->signal_activate().connect([&] {
			auto *row = resultbox->get_selected_row();
			if (row == nullptr || !row->is_visible()) {
				row = resultbox->get_row_at_index(0);
			}
			if (row != nullptr) {
				row->activate();
			}
		});

		resultbox->signal_row_activated().connect([&](auto &row) {
			std::cerr << "launching " << current_apps[row->get_index()]->get_name() << std::endl;
			vector<RefPtr<Gio::File>> files;
			current_apps[row->get_index()]->launch(files);
			window->hide();
		});

		applist.refresh();
	}

	void clear() {
		current_apps.clear();
		app_rows.clear();
	}

	void set_row_to_app(size_t idx, const RefPtr<Gio::DesktopAppInfo> &app) {
		auto &row = app_rows[idx];
		row.row_dbl_title->set_text(app->get_name());
		row.row_dbl_subtitle->set_text(app->get_description());
		row.row_dbl_icon->set_app(RefPtr<Gio::AppInfo>::cast_static(app));
	}
};

unique_ptr<lsh::surface> init_lsh(lsh::manager &lsh_mgr, shared_ptr<Gtk::Window> window) {
	auto window_lsh =
	    std::make_unique<lsh::surface>(lsh_mgr, window, lsh::any_output, lsh::layer::top);
	(*window_lsh)
	    ->set_anchor(lsh::anchor::top | lsh::anchor::left | lsh::anchor::bottom | lsh::anchor::right);
	(*window_lsh)->set_size(0, 0);
	(*window_lsh)->set_keyboard_interactivity(true);
	return window_lsh;
}

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.launcher");
	lsh::manager lsh_mgr(app);

	auto window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
	window->set_default_size(700, 400);
	window->set_decorated(false);
	window->set_app_paintable(true);
	unique_ptr<lsh::surface> window_lsh;

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
		if (!click_rect.intersects(launcher.toplevel->get_allocation())) {
			window->hide();
		}
		return true;
	});

	launcher.toplevel->set_valign(Gtk::Align::ALIGN_CENTER);
	launcher.toplevel->set_halign(Gtk::Align::ALIGN_CENTER);
	launcher.toplevel->set_hexpand(true);
	launcher.toplevel->set_size_request(700, 400);

	wrapper.add(*launcher.toplevel);
	wrapper.show_all();
	window->add(wrapper);

	RefPtr<Gio::SimpleAction> reveal = Gio::SimpleAction::create("reveal");
	reveal->signal_activate().connect([&](const VariantBase &param) {
		window->hide();
		window_lsh = init_lsh(lsh_mgr, window);
		launcher.searchbar->grab_focus();
	});
	app->add_action(reveal);

	app->hold();
	return app->run();
}
