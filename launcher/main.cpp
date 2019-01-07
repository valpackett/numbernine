#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <iostream>
#include <memory>
#include <unordered_map>
#include <utility>
#include "app_list.hpp"
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/surface.hpp"

#define RESPREFIX "/technology/unrelenting/numbernine/launcher/"

class launcher {
 public:
	app_list applist;
	Glib::RefPtr<Gtk::IconTheme> icon_theme = Gtk::IconTheme::get_default();
	std::unordered_map<std::string, Glib::RefPtr<Gdk::Pixbuf>> icon_cache;
	std::vector<Glib::RefPtr<Gio::DesktopAppInfo>> current_apps;
	Gtk::Box *topl = nullptr;
	Gtk::ListBox *resultbox = nullptr;
	Gtk::SearchEntry *searchbar = nullptr;
	std::shared_ptr<Gtk::Window> window;

	launcher(std::shared_ptr<Gtk::Window> w) : window(std::move(std::move(w))) {
		Glib::RefPtr<Gtk::Builder> builder =
		    Gtk::Builder::create_from_resource(RESPREFIX "launcher.glade");
		builder->get_widget("toplevel", topl);
		builder->get_widget("resultbox", resultbox);
		builder->get_widget("searchbar", searchbar);
		clear();
		searchbar->signal_changed().connect([&] {
			clear();
			current_apps.clear();
			for (auto idx : applist.fuzzy_search(searchbar->get_text())) {
				add_row_for_app(applist.apps[idx]);
				current_apps.push_back(applist.apps[idx]);
			}
		});
		resultbox->signal_row_activated().connect([&](auto &row) {
			std::cerr << "launching " << current_apps[row->get_index()]->get_name() << std::endl;
			std::vector<Glib::RefPtr<Gio::File>> files;
			current_apps[row->get_index()]->launch(files);
			window->hide();
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

		Gtk::Image *icon = nullptr;
		builder->get_widget("row-double-icon", icon);

		auto appname = app->get_name();
		title->set_text(appname);
		subtitle->set_text(app->get_description());
		if (icon_cache.count(appname) > 0) {
			icon->set(icon_cache[appname]);
		} else {
			auto *icon_gobj = g_app_info_get_icon(Glib::RefPtr<Gio::AppInfo>::cast_static(app)->gobj());
			if (icon_gobj != nullptr) {
				auto *icon_info_gobj = gtk_icon_theme_lookup_by_gicon_for_scale(
				    icon_theme->gobj(), icon_gobj, 48, topl->get_scale_factor(),
				    GTK_ICON_LOOKUP_FORCE_SIZE);
				if (icon_info_gobj != nullptr) {
					Gtk::IconInfo icon_info(icon_info_gobj);
					auto pixbuf = icon_info.load_icon();
					icon->set(pixbuf);
					icon_cache[appname] = pixbuf;
				}
			}
		}

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
	reveal->signal_activate().connect([&](auto _) {
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
