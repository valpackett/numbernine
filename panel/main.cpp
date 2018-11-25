#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <iostream>
#include <memory>
#include <unordered_map>
#include "gtk-lsh/manager.h"
#include "gtk-lsh/surface.h"
#include "widgets.h"

std::unordered_map<std::string, std::unique_ptr<widget>> widgets;

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.panel");
	lsh::manager lsh_mgr(app);

	auto window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
	window->set_default_size(200, 24);
	window->set_decorated(false);
	auto window_lsh = lsh_mgr.layerize(window, lsh::layer::top);
	window_lsh.set_anchor(lsh::anchor::left | lsh::anchor::bottom | lsh::anchor::right);
	window_lsh.set_size(640, 24);

	Gtk::Box widgetbox;

	auto default_settings = Gio::Settings::create(GSNAMEPREFIX "panel", GSPATHPREFIX "default/");
	Glib::Variant<std::vector<std::pair<Glib::ustring, Glib::ustring>>> widget_conf_list;
	default_settings->get_value("widgets", widget_conf_list);
	for (auto widget_conf : widget_conf_list.get()) {
		widgets.emplace(widget_conf.second, make_widget(widget_conf.first, widget_conf.second));
		if (widgets[widget_conf.second] == nullptr) {
			g_log_structured(G_LOG_DOMAIN, G_LOG_LEVEL_WARNING, "MESSAGE",
			                 "Unknown widget type '%s' (for widget '%s') in panel '%s'",
			                 widget_conf.first.c_str(), widget_conf.second.c_str(), "default",
			                 "N9_PANEL_NAME", "default", "N9_WIDGET_TYPE", widget_conf.first.c_str(),
			                 "N9_WIDGET_NAME", widget_conf.second.c_str());
			continue;
		}
		widgetbox.add(widgets[widget_conf.second]->root());
	}

	window->add(widgetbox);
	window->show_all();
	return app->run(*window);
}
