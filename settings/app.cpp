#include <fcntl.h>
#include <gdk/gdkwayland.h>
#include <glibmm/i18n.h>
#include <gtkmm.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <iostream>
#include "Management_generated.h"
#include "fmt/format.h"
#include "gtk-util/list_box_reuser.hpp"
#include "util.hpp"
#include "wldip-compositor-manager-client-protocol.h"

#define RESPREFIX "/technology/unrelenting/numbernine/settings/"

template <typename T>
static inline T *get_widget(Glib::RefPtr<Gtk::Builder> &builder, Glib::ustring key) {
	T *wdg = nullptr;
	builder->get_widget(key, wdg);
	return wdg;
}

template <typename T>
static inline Glib::RefPtr<T> get_object(Glib::RefPtr<Gtk::Builder> &builder, Glib::ustring key) {
	return Glib::RefPtr<T>::cast_static(builder->get_object(key));
}

struct input_device_row {
	Gtk::Grid *grid = nullptr;
	Gtk::Label *name = nullptr, *desc = nullptr;
	Gtk::Image *icon = nullptr;

	input_device_row(Glib::RefPtr<Gtk::Builder> &builder) {
		builder->get_widget("row-input-device", grid);
		builder->get_widget("input-device-name", name);
		builder->get_widget("input-device-icon", icon);
		builder->get_widget("input-device-description", desc);
	}

	void on_added() { grid->get_parent()->get_style_context()->add_class("n9-settings-row"); }

	Gtk::Grid *toplevel() { return grid; }
};

struct settings_app {
	struct wldip_compositor_manager *cmgr = nullptr;
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::ApplicationWindow *window = nullptr;
	Gtk::HeaderBar *headerbar_main = nullptr;
	Gtk::Stack *stack_main = nullptr;
	Gtk::ListBox *curr_devices = nullptr;
	std::vector<input_device_row> curr_devices_rows;
	std::optional<gutil::list_box_reuser<input_device_row>> inputdevs;

	settings_app() {
		settings = Gio::Settings::create("technology.unrelenting.numbernine.settings",
		                                 "/technology/unrelenting/numbernine/settings/");

		auto builder = Gtk::Builder::create_from_resource(RESPREFIX "settings.glade");
		builder->get_widget("toplevel", window);
		builder->get_widget("headerbar-main", headerbar_main);
		builder->get_widget("stack-main", stack_main);
		builder->get_widget("list-current-devices", curr_devices);

		inputdevs =
		    gutil::list_box_reuser<input_device_row>(RESPREFIX "settings.glade", curr_devices, false);

		settings->bind("mice-accel-speed",
		               get_object<Gtk::Adjustment>(builder, "adj-mouse-speed")->property_value());
		settings->bind("touchpads-accel-speed",
		               get_object<Gtk::Adjustment>(builder, "adj-touchpad-speed")->property_value());
		settings->bind("touchpads-natural-scrolling",
		               get_widget<Gtk::Switch>(builder, "toggle-natural-scrolling")->property_active());
		settings->bind("touchpads-tap-click",
		               get_widget<Gtk::Switch>(builder, "toggle-tap-click")->property_active());
		settings->bind(
		    "touchpads-click-method",
		    get_widget<Gtk::ComboBoxText>(builder, "choose-click-method")->property_active_id());
		settings->bind("touchpads-dwt",
		               get_widget<Gtk::Switch>(builder, "toggle-touchpad-dwt")->property_active());
		settings->bind("touchpads-dwmouse",
		               get_widget<Gtk::Switch>(builder, "toggle-dwmouse")->property_active());

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
			inputdevs->ensure_row_count(input_dev_len);
			size_t i = 0;
			for (const auto device : *seat->input_devices()) {
				auto &row = (*inputdevs)[i++];
				row.name->set_text(device->name()->str());
				std::string desc = fmt::format(_("Vendor ID: {:#06x}, product ID: {:#06x}.\n"),
				                               device->vendor_id(), device->product_id());
				if (inputdev::is_pointer(device)) {
					if (device->disable_while_typing_available()) {
						desc += _("Supports disable-while-typing.\n");
					} else {
						desc += _("Does not support disable-while-typing.\n");
					}
					if (device->left_handed_mode()) {
						desc += _("Supports left-handed mode.\n");
					} else {
						desc += _("Does not support left-handed mode.\n");
					}
					if (device->middle_emulation_available()) {
						desc += _("Supports middle click emulation.\n");
					} else {
						desc += _("Does not support middle click emulation.\n");
					}
					if (inputdev::is_touchpad(device)) {
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
						if (inputdev::supports_button_areas(device)) {
							desc += _("Supports button area based clicks.\n");
						} else {
							desc += _("Does not support button area based clicks.\n");
						}
						if (inputdev::supports_clickfinger(device)) {
							desc += _("Supports finger count based clicks.\n");
						} else {
							desc += _("Does not support finger count based clicks.\n");
						}
					} else {
						row.icon->set_from_icon_name("input-mouse-symbolic", Gtk::ICON_SIZE_LARGE_TOOLBAR);
					}
				} else if (inputdev::is_touchscreen(device)) {
					row.icon->set_from_icon_name("video-display-symbolic", Gtk::ICON_SIZE_LARGE_TOOLBAR);
					desc += fmt::format(g_dngettext(nullptr, "Supports single-finger touch.\n",
					                                "Supports {}-finger touch.\n", device->touch_count()),
					                    device->touch_count());
				} else if (inputdev::is_keyboard(device)) {
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
		munmap(fbuf, recv_stat.st_size);
		close(recv_fd);
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
