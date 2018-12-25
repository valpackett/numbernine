#include "separator.hpp"

separator::separator(const std::string &settings_key) {
	settings =
	    Gio::Settings::create(GSNAMEPREFIX "widgets.separator", GSPATHPREFIX + settings_key + "/");

	sep.property_expand().signal_changed().connect(
	    [this] { sep.set_opacity(sep.property_expand().get_value() ? 0.0 : 1.0); });

	settings->bind("expand", sep.property_expand());

	sep.show_all();
}
