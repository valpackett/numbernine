#include "manager.hpp"
#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include "surface.hpp"
#include "wlr-layer-shell-unstable-v1-client-protocol.h"

namespace lsh {

static void handle_global(void *data, struct wl_registry *registry, uint32_t name,
                          const char *interface, uint32_t /*unused*/) {
	auto *mgr = reinterpret_cast<manager *>(data);
	if (strcmp(interface, "zwlr_layer_shell_v1") == 0) {
		mgr->lshell = reinterpret_cast<struct zwlr_layer_shell_v1 *>(
		    wl_registry_bind(registry, name, &zwlr_layer_shell_v1_interface, 1));
	}
}

static void handle_global_remove(void * /*unused*/, struct wl_registry * /*unused*/,
                                 uint32_t /*unused*/) {}

static const struct wl_registry_listener registry_listener = {handle_global, handle_global_remove};

manager::manager(Glib::RefPtr<Gtk::Application> & /*unused*/) {
	if (lshell == nullptr) {
		auto gddisp = Gdk::Display::get_default();
		if (!GDK_IS_WAYLAND_DISPLAY(gddisp->gobj())) {
			throw std::runtime_error("Not even running on a wayland display??");
		}
		auto *display = gdk_wayland_display_get_wl_display(gddisp->gobj());
		auto *registry = wl_display_get_registry(display);
		wl_registry_add_listener(registry, &registry_listener, this);
		wl_display_dispatch(display);
		wl_display_roundtrip(display);
		if (lshell == nullptr) {
			throw std::runtime_error("Compositor does not offer layer-shell");
		}
	}
}

}  // namespace lsh
