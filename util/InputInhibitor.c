#include <gdk/gdkwayland.h>
#include <stdbool.h>
#include <wayland-client.h>
#include "wlr-input-inhibitor-unstable-v1-client.h"

static struct zwlr_input_inhibit_manager_v1 *input_inhibit_manager = NULL;
static struct zwlr_input_inhibitor_v1 *input_inhibitor = NULL;

static void handle_global(void *data, struct wl_registry *registry, uint32_t name,
                          const char *interface, uint32_t version) {
	if (strcmp(interface, zwlr_input_inhibit_manager_v1_interface.name) == 0) {
		input_inhibit_manager =
		    wl_registry_bind(registry, name, &zwlr_input_inhibit_manager_v1_interface, 1);
	}
}

static void handle_global_remove(void *data, struct wl_registry *registry, uint32_t name) {}

static const struct wl_registry_listener registry_listener = {
    .global = handle_global,
    .global_remove = handle_global_remove,
};

__attribute__((__visibility__("default")))
bool gwl_input_inhibit(GdkDisplay *gdisplay) {
	if (!GDK_IS_WAYLAND_DISPLAY(gdisplay)) {
		return false;
	}

	struct wl_display *display = gdk_wayland_display_get_wl_display(gdisplay);
	struct wl_registry *registry = wl_display_get_registry(display);
	wl_registry_add_listener(registry, &registry_listener, NULL);
	wl_display_dispatch(display);
	wl_display_roundtrip(display);
	if (!input_inhibit_manager) {
		return false;
	}

	input_inhibitor = zwlr_input_inhibit_manager_v1_get_inhibitor(input_inhibit_manager);
	if (!input_inhibitor) {
		return false;
	}

	return true;
}

__attribute__((__visibility__("default")))
bool gwl_input_uninhibit() {
	if (!input_inhibitor) {
		return false;
	}

	zwlr_input_inhibitor_v1_destroy(input_inhibitor);
	return true;
}
