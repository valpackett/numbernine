#define WAYFIRE_PLUGIN
#define WLR_USE_UNSTABLE
extern "C" {
#include <wlr/types/wlr_seat.h>
#include <linux/input-event-codes.h>
#include <linux/input.h>
#include <xkbcommon/xkbcommon.h>
}
#include <plugin.hpp>
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

class wayfire_mod2key : public wf::plugin_interface_t {
	key_callback on_binding = [=](uint32_t value) {
		auto seat = wf::get_core().get_current_seat();

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
		if (section->get_option("ctrl_as_esc", "1")->as_int() == 1) {
			binds.emplace_back(output->add_key(new_static_option("<ctrl>"), &on_binding));
		}
		if (section->get_option("shifts_as_parens", "1")->as_int() == 1) {
			binds.emplace_back(output->add_key(new_static_option("<shift>"), &on_binding));
		}
	}

 public:
	wf::signal_callback_t reload_config;

	void init(wayfire_config *config) override {
		setup_bindings_from_config(config);

		reload_config = [=](wf::signal_data_t *) {
			clear_bindings();
			setup_bindings_from_config(wf::get_core().config);
		};

		wf::get_core().connect_signal("reload-config", &reload_config);
	}

	void fini() override {
		wf::get_core().disconnect_signal("reload-config", &reload_config);
		clear_bindings();
	}
};

DECLARE_WAYFIRE_PLUGIN(wayfire_mod2key);
