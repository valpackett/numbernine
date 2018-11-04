#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include "manager.h"
#include "surface.h"
#include "wlr-layer-shell-unstable-v1-client-protocol.h"

namespace lsh {

static void handle_global(void *data, struct wl_registry *registry, uint32_t name,
                          const char *interface, uint32_t) {
	auto *mgr = reinterpret_cast<manager *>(data);
	if (strcmp(interface, "zwlr_layer_shell_v1") == 0) {
		mgr->lshell = reinterpret_cast<struct zwlr_layer_shell_v1 *>(
		    wl_registry_bind(registry, name, &zwlr_layer_shell_v1_interface, 1));
	}
}

static void handle_global_remove(void *, struct wl_registry *, uint32_t) {}

static const struct wl_registry_listener registry_listener = {handle_global, handle_global_remove};

layer operator|(const layer a, const layer b) {
	return static_cast<layer>(static_cast<int>(a) | static_cast<int>(b));
}

manager::manager(Glib::RefPtr<Gtk::Application> &) {
	if (!lshell) {
		auto gddisp = Gdk::Display::get_default();
		if (!GDK_IS_WAYLAND_DISPLAY(gddisp->gobj())) {
			throw std::runtime_error("Not even running on a wayland display??");
		}
		auto *display = gdk_wayland_display_get_wl_display(gddisp->gobj());
		auto *registry = wl_display_get_registry(display);
		wl_registry_add_listener(registry, &registry_listener, this);
		wl_display_dispatch(display);
		wl_display_roundtrip(display);
		if (!lshell) {
			throw std::runtime_error("Compositor does not offer layer-shell");
		}
	}
}

surface manager::layerize(std::shared_ptr<Gtk::Window> window, layer layer) {
	gtk_widget_realize(reinterpret_cast<GtkWidget *>(window->gobj()));
	auto *gdwnd = window->get_window()->gobj();
	gdk_wayland_window_set_use_custom_surface(gdwnd);
	auto *wlsurf = gdk_wayland_window_get_wl_surface(gdwnd);
	auto *lsurf = zwlr_layer_shell_v1_get_layer_surface(
	    lshell, wlsurf, nullptr, static_cast<zwlr_layer_shell_v1_layer>(layer), "test");
	return surface(lsurf, window);
}

}  // namespace lsh
