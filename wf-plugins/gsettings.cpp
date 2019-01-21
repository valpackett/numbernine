#define WLR_USE_UNSTABLE
#define WAYFIRE_PLUGIN
#include <giomm.h>
#include <glibmm.h>
#include <libinput.h>
#include <unistd.h>
#include <algorithm>
#include <core.hpp>
#include <nonstd/make_unique.hpp>
#include <output.hpp>
#include <plugin.hpp>
#include <sstream>
#include <thread>
#include <view-transform.hpp>
#include <view.hpp>
#include <workspace-manager.hpp>

static inline std::string join(const std::vector<std::string> &v, const char delim) {
	std::ostringstream result;
	for (const auto &i : v) {
		if (&i != &v[0]) {
			result << delim;
		}
		result << i;
	}
	return result.str();
}

struct the_settings {
	Glib::Variant<std::vector<std::pair<std::string, std::string>>> xkb_layouts;
	std::vector<std::string> xkb_options;
	std::string xkb_rule;
	uint32_t kb_repeat_rate, kb_repeat_delay;
	double mouse_cursor_speed, mouse_scroll_speed, touchpad_cursor_speed, touchpad_scroll_speed;
	bool natural_scroll, tap_to_click;
	std::string click_method, scroll_method;
	bool disable_while_typing, disable_touchpad_while_mouse;

	void fill(const Glib::RefPtr<Gio::Settings> &gsettings) {
		gsettings->get_value("xkb-layouts", xkb_layouts);
		xkb_options = gsettings->get_string_array("xkb-options");
		xkb_rule = gsettings->get_string("xkb-rule");
		kb_repeat_rate = gsettings->get_uint("kb-repeat-rate");
		kb_repeat_delay = gsettings->get_uint("kb-repeat-delay");
		mouse_cursor_speed = gsettings->get_double("mice-accel-speed");
		mouse_scroll_speed = gsettings->get_double("mice-scroll-speed");
		touchpad_cursor_speed = gsettings->get_double("touchpads-accel-speed");
		touchpad_scroll_speed = gsettings->get_double("touchpads-scroll-speed");
		natural_scroll = gsettings->get_boolean("touchpads-natural-scrolling");
		tap_to_click = gsettings->get_boolean("touchpads-tap-click");
		click_method = gsettings->get_string("touchpads-click-method");
		scroll_method = gsettings->get_string("touchpads-scroll-method");
		disable_while_typing = gsettings->get_boolean("touchpads-dwt");
		disable_touchpad_while_mouse = gsettings->get_boolean("touchpads-dwmouse");
	}

	void apply(wayfire_config *config) {
		auto input = config->get_section("input");
		std::vector<std::string> layouts, variants;
		auto xkl = xkb_layouts.get();
		std::transform(xkl.cbegin(), xkl.cend(), std::back_inserter(layouts),
		               [](const std::pair<std::string, std::string> x) { return x.first; });
		std::transform(xkl.cbegin(), xkl.cend(), std::back_inserter(variants),
		               [](const std::pair<std::string, std::string> x) { return x.second; });
		input->get_option("xkb_layout", "us")->set_value(join(layouts, ','));
		input->get_option("xkb_variant", "")->set_value(join(variants, ','));
		input->get_option("xkb_options", "compose:ralt,grp:alt_space_toggle")
		    ->set_value(join(xkb_options, ','));
		input->get_option("xkb_rule", "evdev")->set_value(xkb_rule);
		input->get_option("kb_repeat_rate", "40")->set_value(static_cast<int>(kb_repeat_rate));
		input->get_option("kb_repeat_delay", "400")->set_value(static_cast<int>(kb_repeat_delay));
		input->get_option("mouse_cursor_speed", "0.0")->set_value(mouse_cursor_speed);
		input->get_option("mouse_scroll_speed", "1.0")->set_value(mouse_scroll_speed);
		input->get_option("touchpad_cursor_speed", "0.0")->set_value(touchpad_cursor_speed);
		input->get_option("touchpad_scroll_speed", "1.0")->set_value(touchpad_scroll_speed);
		input->get_option("natural_scroll", "1")->set_value(natural_scroll);
		input->get_option("tap_to_click", "1")->set_value(tap_to_click);
		input->get_option("click_method", "default")->set_value(click_method);
		input->get_option("scroll_method", "default")->set_value(scroll_method);
		input->get_option("disable_while_typing", "0")->set_value(disable_while_typing);
		input->get_option("disable_touchpad_while_mouse", "0")->set_value(disable_touchpad_while_mouse);
	}
};

static the_settings settings;

void gsettings_loop(int fd) {
	auto glib = Glib::MainLoop::create();
	Gio::init();
	auto gsettings = Gio::Settings::create("technology.unrelenting.numbernine.settings",
	                                       "/technology/unrelenting/numbernine/settings/");
	settings.fill(gsettings);
	write(fd, "!", 1);
	char buff;
	read(fd, &buff, 1);
	gsettings->signal_changed().connect([=](auto _) {
		log_debug("gsettings updated, notifying main thread");
		settings.fill(gsettings);
		write(fd, "!", 1);
		char buff;
		read(fd, &buff, 1);
	});
	glib->run();
}

static int handle_update(int fd, uint32_t mask, void *data);

struct wayfire_gsettings : public wayfire_plugin_t {
	std::thread loopthread;
	int fd[2] = {0, 0};
	wayfire_config *config = nullptr;

	void init(wayfire_config *config) override {
		this->config = config;
		pipe(fd);
		loopthread = std::thread(gsettings_loop, fd[1]);
		Glib::thread_init();
		wl_event_loop_add_fd(core->ev_loop, fd[0], WL_EVENT_READABLE, handle_update, this);
		handle_update(fd[0], 0, this);
	}

	void fini() {
		close(fd[0]);
		close(fd[1]);
	}

	bool is_unloadable() override { return false; }
};

static int handle_update(int fd, uint32_t mask, void *data) {
	wayfire_gsettings *ctx = reinterpret_cast<wayfire_gsettings *>(data);
	char buff;
	read(fd, &buff, 1);
	log_info("gsettings update received, applying");
	settings.apply(core->config);
	write(fd, "!", 1);
	core->emit_signal("reload-config", nullptr);
	return 1;
}

extern "C" {
wayfire_plugin_t *newInstance() { return new wayfire_gsettings(); }
}
