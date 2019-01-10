#include <wayland-client.h>
#include <filesystem>
#include <iostream>
#include <unordered_map>
#include <vector>
#include "n9config.h"
#include "supervisor.hpp"
#include "wldip-capabilities-client-protocol.h"

namespace fs = std::filesystem;

static struct wl_display *display = nullptr;
static struct wldip_capabilities *caps = nullptr;

static void handle_global(void *data, struct wl_registry *registry, uint32_t name,
                          const char *interface, uint32_t version) {
	if (strcmp(interface, "wldip_capabilities") == 0) {
		caps = reinterpret_cast<struct wldip_capabilities *>(
		    wl_registry_bind(registry, name, &wldip_capabilities_interface, 1));
	}
}

static void handle_global_remove(void *data, struct wl_registry *registry, uint32_t name) {}

static const struct wl_registry_listener registry_listener = {handle_global, handle_global_remove};

static std::unordered_map<uint32_t, int32_t> conn_socks;

static void handle_spawned(void *data, struct wldip_capability_set *wldip_capability_set,
                           uint32_t serial, int32_t connection) {
	conn_socks[serial] = connection;
}

static const struct wldip_capability_set_listener capset_listener = {handle_spawned};

static uint32_t serial = 0;

int connect_with_caps(std::vector<std::string> grants) {
	auto *capset = wldip_capabilities_create_capability_set(caps);
	for (const auto &cap : grants) {
		wldip_capability_set_grant(capset, cap.c_str());
	}
	wldip_capability_set_add_listener(capset, &capset_listener, nullptr);
	wldip_capability_set_spawn(capset, serial);
	while (conn_socks.count(serial) == 0) {
		wl_display_dispatch(display);
		wl_display_roundtrip(display);
	}
	int fd = conn_socks[serial];
	conn_socks.erase(serial);
	serial++;
	return fd;
}

fs::path find_binary(fs::path name) {
	fs::path libexec(N9_LIBEXEC_DIR);
	if (getenv("N9_LIBEXEC_DIR") != nullptr) {
		fs::path from_env(getenv("N9_LIBEXEC_DIR"));
		if (fs::is_directory(from_env)) {
			libexec = from_env;
		}
	}
	if (fs::is_regular_file(libexec / name)) {
		return libexec / name;
	}
	std::cerr << "could not find " << name << std::endl;
	return "";
}

int main(int argc, char *argv[]) {
	display = wl_display_connect(nullptr);
	if (display == nullptr) {
		std::cerr << "failed to create display" << std::endl;
		return -1;
	}

	struct wl_registry *registry = wl_display_get_registry(display);
	wl_registry_add_listener(registry, &registry_listener, nullptr);
	wl_display_dispatch(display);
	wl_display_roundtrip(display);

	supervisor sv;
	sv.add(find_binary("n9-wallpaper"), {"n9-wallpaper", nullptr},
	       []() { return connect_with_caps({"layer-shell"}); });
	sv.add(find_binary("n9-panel"), {"n9-panel", nullptr},
	       []() { return connect_with_caps({"layer-shell"}); });
	sv.add(find_binary("n9-launcher"), {"n9-launcher", nullptr},
	       []() { return connect_with_caps({"layer-shell"}); });
	sv.add(find_binary("n9-notification-daemon"), {"n9-notification-daemon", nullptr},
	       []() { return connect_with_caps({"layer-shell"}); });
	sv.run();
}
