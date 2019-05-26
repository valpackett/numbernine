#include "manager.hpp"
#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <wayland-client.hpp>
#include "surface.hpp"

namespace lsh {

using namespace wayland;

manager::manager(Glib::RefPtr<Gtk::Application>& /*unused*/) {
	if (!lshell) {
		auto gddisp = Gdk::Display::get_default();
		if (!GDK_IS_WAYLAND_DISPLAY(gddisp->gobj())) {
			throw std::runtime_error("Not even running on a wayland display??");
		}
		display_t disp(gdk_wayland_display_get_wl_display(gddisp->gobj()));
		auto reg = disp.get_registry();
		reg.on_global() = [&](std::uint32_t name, const std::string& interface, std::uint32_t version) {
			if (interface == zwlr_layer_shell_v1_t::interface_name) {
				reg.bind(name, lshell, version);
			} else if (interface == zwlr_input_inhibit_manager_v1_t::interface_name) {
				reg.bind(name, inhib, version);
			}
		};
		disp.roundtrip();
		if (!lshell) {
			throw std::runtime_error("Compositor does not offer layer-shell");
		}
	}
}

std::optional<wayland::zwlr_input_inhibitor_v1_t> manager::inhibit() {
	if (!inhib.proxy_has_object()) {
		return {};
	}
	return inhib.get_inhibitor();
}

}  // namespace lsh
