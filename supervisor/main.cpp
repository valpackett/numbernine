#include <wayland-client.h>
#include <iostream>
#include "supervisor.hpp"
#include "weston-desktop-shell-client-protocol.h"

static struct weston_desktop_shell *dsh = nullptr;

static void handle_global(void *data, struct wl_registry *registry, uint32_t name,
                          const char *interface, uint32_t version) {
	if (strcmp(interface, "weston_desktop_shell") == 0) {
		dsh = reinterpret_cast<struct weston_desktop_shell *>(
		    wl_registry_bind(registry, name, &weston_desktop_shell_interface, 1));
	}
}

static void handle_global_remove(void *data, struct wl_registry *registry, uint32_t name) {}

static const struct wl_registry_listener registry_listener = {handle_global, handle_global_remove};

int main(int argc, char *argv[]) {
	struct wl_display *display = wl_display_connect(nullptr);
	if (display == nullptr) {
		std::cerr << "failed to create display" << std::endl;
		return -1;
	}

	struct wl_registry *registry = wl_display_get_registry(display);
	wl_registry_add_listener(registry, &registry_listener, nullptr);
	wl_display_dispatch(display);
	wl_display_roundtrip(display);

	process wallpaper("n9-wallpaper");
	process panel("n9-panel");

	if (dsh != nullptr) {
		nanosleep((const struct timespec[]){{.tv_sec = 0, .tv_nsec = 400000000}}, nullptr);
		weston_desktop_shell_desktop_ready(dsh);
		wl_display_dispatch(display);
		wl_display_roundtrip(display);
	}

	supervisor sv;
	sv.add(wallpaper);
	sv.add(panel);
	sv.run();
}
