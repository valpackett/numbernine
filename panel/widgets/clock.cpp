#include "clock.hpp"

klock::klock(const std::string &settings_key) {
	settings = Gio::Settings::create(GSNAMEPREFIX "widgets.clock", GSPATHPREFIX + settings_key + "/");

	settings->signal_changed("format").connect([this](auto _) {
		fmt = settings->get_string("format");
		tick();
	});

	// TODO: update less often when seconds aren't in fmt
	timer = Glib::signal_timeout().connect_seconds(
	    [this] {
		    tick();
		    return true;
	    },
	    1);

	fmt = settings->get_string("format");
	tick();
	lbl.show_all();
}

void klock::tick() { lbl.set_text(Glib::DateTime::create_now_local().format(fmt)); }

klock::~klock() { timer.disconnect(); }
