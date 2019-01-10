#include "quicklaunch.hpp"

quicklaunch::quicklaunch(const std::string &settings_key) {
	settings =
	    Gio::Settings::create(GSNAMEPREFIX "widgets.quicklaunch", GSPATHPREFIX + settings_key + "/");

	// set_image to create the GtkImage initially
	termbtn.set_image_from_icon_name(settings->get_string("icon-name"));
	// and now bind that image to change its icon live
	settings->bind("icon-name", termbtn.get_image(), "icon-name");

	// getting from settings inside the callback guarantees live update
	termbtn.signal_clicked().connect([this] {
		std::vector<std::string> argv = settings->get_string_array("command");
		Glib::spawn_async(Glib::getenv("HOME"), argv);
	});

	auto css = termbtn.get_style_context();
	css->add_class("n9-panel-widget");
	css->add_class("n9-panel-quicklaunch");

	termbtn.show_all();
}
