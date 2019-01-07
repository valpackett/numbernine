#include "remoteaction.hpp"
#include "org.gtk.Actions_proxy.h"

remoteaction::remoteaction(const std::string &settings_key) {
	settings =
	    Gio::Settings::create(GSNAMEPREFIX "widgets.remoteaction", GSPATHPREFIX + settings_key + "/");

	// set_image to create the GtkImage initially
	termbtn.set_image_from_icon_name(settings->get_string("icon-name"));
	// and now bind that image to change its icon live
	settings->bind("icon-name", termbtn.get_image(), "icon-name");

	// getting from settings inside the callback guarantees live update
	termbtn.signal_clicked().connect([this] {
		org::gtk::Actions::createForBus(
		    Gio::DBus::BUS_TYPE_SESSION, Gio::DBus::PROXY_FLAGS_DO_NOT_LOAD_PROPERTIES,
		    settings->get_string("bus-name"), settings->get_string("bus-path"), [this](auto result) {
			    auto proxy = org::gtk::Actions::createForBusFinish(result);
			    const std::vector<Glib::VariantBase> params;
			    const std::map<Glib::ustring, Glib::VariantBase> platform_data;
			    proxy->Activate(settings->get_string("action"), params, platform_data, [](auto _) {});
		    });
	});

	termbtn.show_all();
}
