#include <fcntl.h>
#include <gdk/gdkwayland.h>
#include <glibmm/i18n.h>
#include <gtkmm.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <iostream>
#include "Management_generated.h"
#include "fmt/format.h"
#include "wldip-compositor-manager-client-protocol.h"

#define RESPREFIX "/technology/unrelenting/numbernine/settings/"

template <typename T>
T *get_widget(Glib::RefPtr<Gtk::Builder> &builder, Glib::ustring key) {
	T *wdg = nullptr;
	builder->get_widget(key, wdg);
	return wdg;
}

struct input_device_row {
	Gtk::Grid *grid = nullptr;
	Gtk::Label *name = nullptr, *desc = nullptr;
	Gtk::Image *icon = nullptr;
};

struct settings_app {
	struct wldip_compositor_manager *cmgr = nullptr;
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::ApplicationWindow *window = nullptr;
	Gtk::HeaderBar *headerbar_main = nullptr;
	Gtk::Stack *stack_main = nullptr;
	Gtk::ListBox *curr_devices = nullptr;
	std::vector<input_device_row> curr_devices_rows;

	settings_app() {
		settings = Gio::Settings::create("technology.unrelenting.numbernine.settings",
		                                 "/technology/unrelenting/numbernine/settings/");

		auto builder = Gtk::Builder::create_from_resource(RESPREFIX "settings.glade");
		builder->get_widget("toplevel", window);
		builder->get_widget("headerbar-main", headerbar_main);
		builder->get_widget("stack-main", stack_main);
		builder->get_widget("list-current-devices", curr_devices);

		settings->bind("touchpads-natural-scrolling",
		               get_widget<Gtk::Switch>(builder, "toggle-natural-scrolling")->property_active());

		auto css = Gtk::CssProvider::create();
		css->load_from_resource(RESPREFIX "style.css");
		window->get_style_context()->add_provider_for_screen(Gdk::Screen::get_default(), css,
		                                                     GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

		auto update_title = [=] {
			headerbar_main->set_title(
			    stack_main->child_property_title(*stack_main->property_visible_child().get_value())
			        .get_value());
		};
		update_title();
		stack_main->property_visible_child().signal_changed().connect(update_title);

		window->reference();
	}

	void on_new_compositor_state(const wldip::compositor_management::CompositorState *state) {
		using namespace wldip::compositor_management;
		for (const auto seat : *state->seats()) {
			auto input_dev_len = seat->input_devices()->size();
			auto input_dev_rows = curr_devices->get_children().size();
			if (input_dev_len < input_dev_rows) {
				for (size_t i = input_dev_len; i < input_dev_rows; i++) {
					curr_devices->remove(*curr_devices->get_row_at_index(i));
					curr_devices_rows.erase(curr_devices_rows.begin() + i);
				}
			} else if (input_dev_len > input_dev_rows) {
				for (size_t i = input_dev_rows; i < input_dev_len; i++) {
					auto builder = Gtk::Builder::create_from_resource(RESPREFIX "settings.glade");
					input_device_row row;
					builder->get_widget("row-input-device", row.grid);
					builder->get_widget("input-device-name", row.name);
					builder->get_widget("input-device-icon", row.icon);
					builder->get_widget("input-device-description", row.desc);
					curr_devices->insert(*row.grid, -1);
					row.grid->reference();
					row.grid->get_parent()->get_style_context()->add_class("n9-settings-row");
					curr_devices_rows.push_back(row);
				}
			}
			size_t i = 0;
			for (const auto device : *seat->input_devices()) {
				auto &row = curr_devices_rows[i++];
				row.name->set_text(device->name()->str());
				std::string desc = fmt::format(_("Vendor ID: {:#06x}, product ID: {:#06x}.\n"),
				                               device->vendor_id(), device->product_id());
				if (std::find(device->capabilites()->begin(), device->capabilites()->end(),
				              DeviceCapability_Pointer) != device->capabilites()->end()) {
					auto has_gestures =
					    std::find(device->capabilites()->begin(), device->capabilites()->end(),
					              DeviceCapability_Gesture) != device->capabilites()->end();
					if (has_gestures || device->tap_finger_count() > 0) {
						row.icon->set_from_icon_name("input-touchpad-symbolic", Gtk::ICON_SIZE_LARGE_TOOLBAR);
						desc += fmt::format(_("{:.1f} × {:.1f} mm.\n"), device->mm_width(), device->mm_width());
						desc += fmt::format(
						    g_dngettext(nullptr, "Supports single-finger tapping.\n",
						                "Supports {}-finger tapping.\n", device->tap_finger_count()),
						    device->tap_finger_count());
						if (device->natural_scrolling_available()) {
							desc += _("Supports natural scrolling.\n");
						} else {
							desc += _("Does not support natural scrolling.\n");
						}
					} else {
						row.icon->set_from_icon_name("input-mouse-symbolic", Gtk::ICON_SIZE_LARGE_TOOLBAR);
					}
				} else if (std::find(device->capabilites()->begin(), device->capabilites()->end(),
				                     DeviceCapability_Touch) != device->capabilites()->end()) {
					row.icon->set_from_icon_name("video-display-symbolic", Gtk::ICON_SIZE_LARGE_TOOLBAR);
					desc += fmt::format(g_dngettext(nullptr, "Supports single-finger touch.\n",
					                                "Supports {}-finger touch.\n", device->touch_count()),
					                    device->touch_count());
				} else if (std::find(device->capabilites()->begin(), device->capabilites()->end(),
				                     DeviceCapability_Keyboard) != device->capabilites()->end()) {
					row.icon->set_from_icon_name("input-keyboard-symbolic", Gtk::ICON_SIZE_LARGE_TOOLBAR);
				}
				row.desc->set_text(desc);
			}
		}
	}
};

static void handle_global(void *data, struct wl_registry *registry, uint32_t name,
                          const char *interface, uint32_t /*unused*/) {
	auto *app = reinterpret_cast<settings_app *>(data);
	if (strcmp(interface, "wldip_compositor_manager") == 0) {
		app->cmgr = reinterpret_cast<struct wldip_compositor_manager *>(
		    wl_registry_bind(registry, name, &wldip_compositor_manager_interface, 1));
	}
}

static void handle_global_remove(void * /*unused*/, struct wl_registry * /*unused*/,
                                 uint32_t /*unused*/) {}

static const struct wl_registry_listener registry_listener = {handle_global, handle_global_remove};

static void on_update(void *data, struct wldip_compositor_manager *shooter, int recv_fd) {
	struct stat recv_stat {};
	fstat(recv_fd, &recv_stat);
	void *fbuf = mmap(nullptr, recv_stat.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, recv_fd, 0);
	const auto state = wldip::compositor_management::GetCompositorState(fbuf);
	auto *app = reinterpret_cast<settings_app *>(data);
	Glib::signal_idle().connect([=] {
		app->on_new_compositor_state(state);
		return false;
	});
}

static const struct wldip_compositor_manager_listener mgmt_listener = {on_update};

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.settings");
	settings_app sapp;

	auto gddisp = Gdk::Display::get_default();
	if (!GDK_IS_WAYLAND_DISPLAY(gddisp->gobj())) {
		throw std::runtime_error(_("Not even running on a wayland display??"));
	}
	auto *display = gdk_wayland_display_get_wl_display(gddisp->gobj());
	auto *registry = wl_display_get_registry(display);
	wl_registry_add_listener(registry, &registry_listener, &sapp);
	wl_display_dispatch(display);
	wl_display_roundtrip(display);
	wldip_compositor_manager_add_listener(sapp.cmgr, &mgmt_listener, &sapp);
	wldip_compositor_manager_get(sapp.cmgr);
	wldip_compositor_manager_subscribe(
	    sapp.cmgr, WLDIP_COMPOSITOR_MANAGER_TOPIC_OUTPUTS | WLDIP_COMPOSITOR_MANAGER_TOPIC_INPUTDEVS);

	app->run(*sapp.window);
}
