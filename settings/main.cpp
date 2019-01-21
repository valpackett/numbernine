#include <fcntl.h>
#include <gdk/gdkwayland.h>
#include <glibmm/i18n.h>
#include <gtkmm.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <iostream>
#include "fmt/format.h"
#include "gtk-util/button_toggler.hpp"
#include "gtk-util/list_box_reuser.hpp"
#include "xkb.hpp"

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
	xkbdb xkbdb;
	Glib::Variant<std::vector<std::pair<std::string, std::string>>> xkb_layouts;
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::ApplicationWindow *window = nullptr;
	Gtk::Dialog *dialog_add_keyboard_layout = nullptr;
	Gtk::TreeView *tree_add_keyboard_layout = nullptr;
	Glib::RefPtr<Gtk::TreeStore> tree_store_xkb_layouts;
	Gtk::HeaderBar *headerbar_main = nullptr;
	Gtk::Stack *stack_main = nullptr;
	Gtk::ListBox *kb_layouts = nullptr;
	Gtk::ListBox *curr_devices = nullptr;
	std::vector<input_device_row> curr_devices_rows;
	std::optional<gutil::list_box_reuser<input_device_row>> inputdevs;
	gutil::button_toggler *output_toggler = nullptr;

	settings_app() {
		settings = Gio::Settings::create("technology.unrelenting.numbernine.settings",
		                                 "/technology/unrelenting/numbernine/settings/");

		auto builder = Gtk::Builder::create_from_resource(RESPREFIX "settings.glade");
		builder->get_widget("toplevel", window);
		builder->get_widget("headerbar-main", headerbar_main);
		builder->get_widget("stack-main", stack_main);
		builder->get_widget("list-keyboard-layouts", kb_layouts);
		builder->get_widget("list-current-devices", curr_devices);
		builder->get_widget_derived("selector-output", output_toggler);

		auto dbuilder = Gtk::Builder::create_from_resource(RESPREFIX "dialogs.glade");
		dbuilder->get_widget("dialog-add-keyboard-layout", dialog_add_keyboard_layout);
		dbuilder->get_widget("tree-add-keyboard-layout", tree_add_keyboard_layout);
		tree_store_xkb_layouts = get_object<Gtk::TreeStore>(dbuilder, "tree-store-xkb-layouts");

		inputdevs =
		    gutil::list_box_reuser<input_device_row>(RESPREFIX "settings.glade", curr_devices, false);

		settings->bind("mice-accel-speed",
		               get_object<Gtk::Adjustment>(builder, "adj-mouse-speed")->property_value());
		settings->bind(
		    "mice-scroll-speed",
		    get_object<Gtk::Adjustment>(builder, "adj-mouse-scroll-speed")->property_value());
		settings->bind("touchpads-accel-speed",
		               get_object<Gtk::Adjustment>(builder, "adj-touchpad-speed")->property_value());
		settings->bind(
		    "touchpads-scroll-speed",
		    get_object<Gtk::Adjustment>(builder, "adj-touchpad-scroll-speed")->property_value());
		settings->bind("touchpads-natural-scrolling",
		               get_widget<Gtk::Switch>(builder, "toggle-natural-scrolling")->property_active());
		settings->bind("touchpads-tap-click",
		               get_widget<Gtk::Switch>(builder, "toggle-tap-click")->property_active());
		settings->bind(
		    "touchpads-click-method",
		    get_widget<Gtk::ComboBoxText>(builder, "choose-click-method")->property_active_id());
		settings->bind(
		    "touchpads-scroll-method",
		    get_widget<Gtk::ComboBoxText>(builder, "choose-scroll-method")->property_active_id());
		settings->bind("touchpads-dwt",
		               get_widget<Gtk::Switch>(builder, "toggle-touchpad-dwt")->property_active());
		settings->bind("touchpads-dwmouse",
		               get_widget<Gtk::Switch>(builder, "toggle-dwmouse")->property_active());

		settings->signal_changed().connect([&](auto _) { on_new_settings(); });
		on_new_settings();

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

		for (const auto &l : xkbdb.layouts) {
			Gtk::TreeModel::iterator it = tree_store_xkb_layouts->append();
			it->set_value(0, l.first);
			it->set_value(1, l.second.desc);
			it->set_value(2, l.first);
			for (const auto &v : l.second.variants) {
				Gtk::TreeModel::iterator iit = tree_store_xkb_layouts->append(it->children());
				iit->set_value(0, fmt::format("{}({})", l.first, v.first));
				iit->set_value(1, v.second);
				iit->set_value(2, l.first);
				iit->set_value(3, v.first);
			}
		}

		window->add_action("add-keyboard-layout", [&]() {
			dialog_add_keyboard_layout->set_transient_for(*window);
			if (dialog_add_keyboard_layout->run() == Gtk::RESPONSE_OK) {
				std::string layout, variant;
				tree_add_keyboard_layout->get_selection()->get_selected()->get_value(2, layout);
				tree_add_keyboard_layout->get_selection()->get_selected()->get_value(3, variant);
				std::vector<std::tuple<Glib::ustring, Glib::ustring>> v;
				for (const auto &p : xkb_layouts.get()) {
					v.push_back(std::make_tuple(p.first, p.second));
				}
				v.push_back(std::make_tuple(layout, variant));
				settings->set_value(
				    "xkb-layouts",
				    Glib::Variant<std::vector<std::tuple<Glib::ustring, Glib::ustring>>>::create(v));
			}
			dialog_add_keyboard_layout->hide();
		});

		window->add_action("remove-keyboard-layout", [&]() {
			auto idx = kb_layouts->get_selected_row()->get_index();
			int i = 0;
			std::vector<std::tuple<Glib::ustring, Glib::ustring>> v;
			for (const auto &p : xkb_layouts.get()) {
				if (i != idx) {
					v.push_back(std::make_tuple(p.first, p.second));
				}
				i++;
			}
			settings->set_value(
			    "xkb-layouts",
			    Glib::Variant<std::vector<std::tuple<Glib::ustring, Glib::ustring>>>::create(v));
			// TODO notification bar with undo
		});

		window->reference();
	}

	void on_new_settings() {
		for (auto &c : kb_layouts->get_children()) {
			kb_layouts->remove(*c);
		}
		settings->get_value("xkb-layouts", xkb_layouts);
		for (auto &layout : xkb_layouts.get()) {
			auto *lbl = new Gtk::Label;
			auto layname = xkbdb.layouts[layout.first].desc;
			auto varname = xkbdb.layouts[layout.first].variants[layout.second];
			lbl->set_label(varname.length() == 0 ? layname : fmt::format("{} - {}", layname, varname));
			lbl->set_alignment(Gtk::ALIGN_START);
			lbl->show();
			kb_layouts->append(*lbl);
			kb_layouts->get_row_at_index(kb_layouts->get_children().size() - 1)
			    ->get_style_context()
			    ->add_class("n9-settings-row");
		}
	}

#if 0
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

		output_toggler->clear();
		for (const auto output : *state->outputs()) {
			Glib::RefPtr<Gtk::ToggleButton> btn(new Gtk::ToggleButton);
			btn->set_label(output->name()->str());
			output_toggler->append(btn);
			btn->show();
		}
	}
#endif
};

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.settings");
	settings_app sapp;

#if 0
	auto gddisp = Gdk::Display::get_default();
	if (!GDK_IS_WAYLAND_DISPLAY(gddisp->gobj())) {
		throw std::runtime_error(_("Not even running on a wayland display??"));
	}
#endif

	app->run(*sapp.window);
}
