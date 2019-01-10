#include "panel.hpp"
#include "widgets.hpp"

panel::panel(const std::string& key, lsh::manager& lsh_mgr, GdkMonitor* monitor)
    : settings_key(key) {
	settings = Gio::Settings::create(GSNAMEPREFIX "panel", GSPATHPREFIX + key + "/");
	window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
	window->set_default_size(200, 24);
	window->set_decorated(false);
	layer_surface.emplace(lsh_mgr, window, monitor, lsh::layer::top);
	layer_surface->set_anchor(lsh::anchor::left | lsh::anchor::bottom | lsh::anchor::right);
	layer_surface->set_size(640, 24);
	layer_surface->set_exclusive_zone(24);

	recreate_widgets();
	window->add(widgetbox);

	auto css_prov = Gtk::CssProvider::create();
	css_prov->load_from_resource(RESPREFIX "style.css");
	auto css = window->get_style_context();
	css->add_provider_for_screen(Gdk::Screen::get_default(), css_prov,
	                             GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
	css->add_class("n9-panel");

	window->show_all();
}

void panel::recreate_widgets() {
	Glib::Variant<std::vector<std::pair<Glib::ustring, Glib::ustring>>> widget_conf_list;
	settings->get_value("widgets", widget_conf_list);
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
		widgets[widget_conf.second]->root().show_all();
	}
}

panel::~panel() = default;
