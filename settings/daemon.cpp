#include <gdk/gdkwayland.h>
#include <glibmm/i18n.h>
#include <gtkmm.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <iostream>
#include "Management_generated.h"
#include "util.hpp"
#include "wldip-compositor-manager-client-protocol.h"

class state_holder {
	int fd;
	size_t size;
	void *fbuf;
	const wldip::compositor_management::CompositorState *state;

 public:
	state_holder(int recv_fd) : fd(recv_fd) {
		struct stat recv_stat {};
		fstat(fd, &recv_stat);
		size = recv_stat.st_size;
		fbuf = mmap(nullptr, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
		state = wldip::compositor_management::GetCompositorState(fbuf);
	}

	const wldip::compositor_management::CompositorState *data() { return state; }

	~state_holder() {
		munmap(fbuf, size);
		close(fd);
	}

	state_holder(state_holder &&) = delete;
};

struct settings_daemon {
	struct wldip_compositor_manager *cmgr = nullptr;
	Glib::RefPtr<Gio::Settings> settings;
	std::unique_ptr<state_holder> state;

	settings_daemon() {
		settings = Gio::Settings::create("technology.unrelenting.numbernine.settings",
		                                 "/technology/unrelenting/numbernine/settings/");

		settings->signal_changed().connect([this](auto _) { ensure_input_settings_applied(); });
	}

	void on_new_compositor_state(std::unique_ptr<state_holder> new_state) {
		state = std::move(new_state);
		ensure_input_settings_applied();
	}

	void ensure_input_settings_applied() {
		// using namespace wldip::compositor_management;
		uint32_t seat_idx = 0;
		for (const auto seat : *state->data()->seats()) {
			uint32_t dev_idx = 0;
			for (const auto device : *seat->input_devices()) {
				auto should_be_natural = settings->get_boolean("touchpads-natural-scrolling");
				if (inputdev::is_touchpad(device) && device->natural_scrolling() != should_be_natural) {
					wldip_compositor_manager_device_set_natural_scrolling(cmgr, seat_idx, dev_idx,
					                                                      should_be_natural);
				}
				dev_idx++;
			}
			seat_idx++;
		}
	}
};

static void handle_global(void *data, struct wl_registry *registry, uint32_t name,
                          const char *interface, uint32_t /*unused*/) {
	auto *daemon = reinterpret_cast<settings_daemon *>(data);
	if (strcmp(interface, "wldip_compositor_manager") == 0) {
		daemon->cmgr = reinterpret_cast<struct wldip_compositor_manager *>(
		    wl_registry_bind(registry, name, &wldip_compositor_manager_interface, 1));
	}
}

static void handle_global_remove(void * /*unused*/, struct wl_registry * /*unused*/,
                                 uint32_t /*unused*/) {}

static const struct wl_registry_listener registry_listener = {handle_global, handle_global_remove};

static void on_update(void *data, struct wldip_compositor_manager *shooter, int recv_fd) {
	auto *daemon = reinterpret_cast<settings_daemon *>(data);
	Glib::signal_idle().connect([=] {
		auto holder = std::make_unique<state_holder>(recv_fd);
		daemon->on_new_compositor_state(std::move(holder));
		return false;
	});
}

static const struct wldip_compositor_manager_listener mgmt_listener = {on_update};

int main(int argc, char *argv[]) {
	auto app =
	    Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.settings-daemon");
	settings_daemon daemon;

	auto gddisp = Gdk::Display::get_default();
	if (!GDK_IS_WAYLAND_DISPLAY(gddisp->gobj())) {
		throw std::runtime_error(_("Not even running on a wayland display??"));
	}
	auto *display = gdk_wayland_display_get_wl_display(gddisp->gobj());
	auto *registry = wl_display_get_registry(display);
	wl_registry_add_listener(registry, &registry_listener, &daemon);
	wl_display_dispatch(display);
	wl_display_roundtrip(display);
	wldip_compositor_manager_add_listener(daemon.cmgr, &mgmt_listener, &daemon);
	wldip_compositor_manager_get(daemon.cmgr);
	wldip_compositor_manager_subscribe(daemon.cmgr, WLDIP_COMPOSITOR_MANAGER_TOPIC_OUTPUTS |
	                                                    WLDIP_COMPOSITOR_MANAGER_TOPIC_INPUTDEVS);

	app->hold();
	app->run();
}
