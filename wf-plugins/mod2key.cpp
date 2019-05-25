#define WLR_USE_UNSTABLE
#define WAYFIRE_PLUGIN
#include <linux/input-event-codes.h>
#include <linux/input.h>
#include <xkbcommon/xkbcommon.h>
#include <config.hpp>
#include <core.hpp>
#include <output.hpp>

static void tap_wlr_key(wlr_seat *seat, uint32_t key) {
	struct timespec now {};
	clock_gettime(CLOCK_MONOTONIC, &now);
	auto ms = now.tv_nsec / 1000;
	wlr_seat_keyboard_notify_key(seat, ms, key, WLR_KEY_PRESSED);
	wlr_seat_keyboard_notify_key(seat, ms + 1, key, WLR_KEY_RELEASED);
}

static void with_wlr_modifier(wlr_seat *seat, xkb_mod_mask_t mod, const std::function<void()> &cb) {
	wlr_keyboard_modifiers mods_with{
	    .depressed = mod,
	    .latched = 0,
	    .locked = 0,
	    .group = 0,
	};
	wlr_seat_keyboard_notify_modifiers(seat, &mods_with);
	cb();
	wlr_keyboard_modifiers mods_without{
	    .depressed = 0,
	    .latched = 0,
	    .locked = 0,
	    .group = 0,
	};
	wlr_seat_keyboard_notify_modifiers(seat, &mods_without);
}

class wayfire_mod2key : public wayfire_plugin_t {
	key_callback on_binding = [=](uint32_t value) {
		auto seat = core->get_current_seat();

		xkb_keycode_t keycode = value + 8;
		auto keyboard = wlr_seat_get_keyboard(seat);
		const xkb_keysym_t *keysyms;
		auto keysyms_len = xkb_state_key_get_syms(keyboard->xkb_state, keycode, &keysyms);

		for (int i = 0; i < keysyms_len; i++) {
			auto key = keysyms[i];

			if (key == XKB_KEY_Control_L) {
				tap_wlr_key(seat, KEY_ESC);
			} else if (key == XKB_KEY_Shift_L || key == XKB_KEY_Shift_R) {
				with_wlr_modifier(seat, WLR_MODIFIER_SHIFT,
				                  [=] { tap_wlr_key(seat, key == XKB_KEY_Shift_L ? KEY_9 : KEY_0); });
			}
		}
	};

	std::vector<wf_binding *> binds{};

	void clear_bindings() {
		for (const auto b : binds) {
			output->rem_binding(b);
		}
		binds.clear();
	}

	void setup_bindings_from_config(wayfire_config *config) {
		auto section = config->get_section("mod2key");
		if (section->get_option("ctrl_as_esc", "0")->as_int() == 1) {
			binds.emplace_back(output->add_key(new_static_option("<ctrl>"), &on_binding));
		}
		if (section->get_option("shifts_as_parens", "0")->as_int() == 1) {
			binds.emplace_back(output->add_key(new_static_option("<shift>"), &on_binding));
		}
	}

 public:
	signal_callback_t reload_config;

	void init(wayfire_config *config) override {
		setup_bindings_from_config(config);

		reload_config = [=](signal_data *) {
			clear_bindings();
			setup_bindings_from_config(core->config);
		};

		core->connect_signal("reload-config", &reload_config);
	}

	void fini() override {
		core->disconnect_signal("reload-config", &reload_config);
		clear_bindings();
	}
};

extern "C" {
wayfire_plugin_t *newInstance() { return new wayfire_mod2key(); }
}
