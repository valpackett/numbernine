#pragma once
#include <gtkmm.h>
#include <memory>
#include <optional>
#include <unordered_map>
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/surface.hpp"
#include "widgets/widget.hpp"

class panel {
	const std::string settings_key;
	Glib::RefPtr<Gio::Settings> settings;
	std::shared_ptr<Gtk::Window> window;
	std::optional<lsh::surface> layer_surface;
	Gtk::Box widgetbox;
	std::unordered_map<std::string, std::unique_ptr<widget>> widgets;

 public:
	panel(const std::string& key, lsh::manager& lsh_mgr);
	void recreate_widgets();
	std::shared_ptr<Gtk::Window> get_window() { return window; };
	~panel();
};
