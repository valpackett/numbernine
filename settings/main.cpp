#define HANDY_USE_UNSTABLE_API
#include <fcntl.h>
#include <gdk/gdkwayland.h>
#include <glibmm/i18n.h>
#include <gtkmm.h>
#include <libhandy-0.0/handy.h>
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

struct kb_layout_row {
	Gtk::Grid *grid = nullptr;
	Gtk::Label *name = nullptr, *desc = nullptr;

	kb_layout_row(Glib::RefPtr<Gtk::Builder> &builder) {
		builder->get_widget("row-kb-layout", grid);
		builder->get_widget("kb-layout-name", name);
		builder->get_widget("kb-layout-description", desc);
	}

	void on_added() { grid->get_parent()->get_style_context()->add_class("n9-settings-row"); }

	Gtk::Grid *toplevel() { return grid; }
};

struct settings_app {
	xkbdb xkbdb;
	Glib::Variant<std::vector<std::pair<std::string, std::string>>> xkb_layouts;
	Glib::RefPtr<Gio::Settings> settings, wpsettings;
	Gtk::ApplicationWindow *window = nullptr;
	Gtk::Button *header_back = nullptr;
	HdyLeaflet *header_leaflet = nullptr, *content_leaflet = nullptr;
	Gtk::Revealer *header_back_revealer = nullptr;
	Gtk::Dialog *dialog_add_keyboard_layout = nullptr;
	Gtk::TreeView *tree_add_keyboard_layout = nullptr;
	Glib::RefPtr<Gtk::TreeStore> tree_store_xkb_layouts;
	Gtk::HeaderBar *headerbar_main = nullptr, *headerbar_sidebar = nullptr;
	Gtk::Stack *stack_main = nullptr;
	Gtk::StackSidebar *switcher_main = nullptr;
	Gtk::FileChooserButton *chooser_wp = nullptr;
	Gtk::ListBox *kb_layouts = nullptr;
	Gtk::ListBox *curr_devices = nullptr;
	std::optional<gutil::list_box_reuser<input_device_row>> inputdevs;
	std::optional<gutil::list_box_reuser<kb_layout_row>> kblayouts;
	gutil::button_toggler *output_toggler = nullptr;

	settings_app() {
		settings = Gio::Settings::create("technology.unrelenting.numbernine.settings",
		                                 "/technology/unrelenting/numbernine/settings/");
		wpsettings = Gio::Settings::create("technology.unrelenting.numbernine.wallpaper",
		                                   "/technology/unrelenting/numbernine/wallpaper/");

		auto builder = Gtk::Builder::create_from_resource(RESPREFIX "settings.glade");
		builder->get_widget("toplevel", window);
		builder->get_widget("header-back-button", header_back);
		builder->get_widget("header-back-button-revealer", header_back_revealer);
		header_leaflet = HDY_LEAFLET(gtk_builder_get_object(builder->gobj(), "header-leaflet"));
		content_leaflet = HDY_LEAFLET(gtk_builder_get_object(builder->gobj(), "content-leaflet"));
		builder->get_widget("headerbar-main", headerbar_main);
		builder->get_widget("headerbar-sidebar", headerbar_sidebar);
		builder->get_widget("stack-main", stack_main);
		builder->get_widget("switcher-main", switcher_main);
		builder->get_widget("file-wallpaper", chooser_wp);
		builder->get_widget("list-keyboard-layouts", kb_layouts);
		builder->get_widget("list-current-devices", curr_devices);
		builder->get_widget_derived("selector-output", output_toggler);

		auto dbuilder = Gtk::Builder::create_from_resource(RESPREFIX "dialogs.glade");
		dbuilder->get_widget("dialog-add-keyboard-layout", dialog_add_keyboard_layout);
		dbuilder->get_widget("tree-add-keyboard-layout", tree_add_keyboard_layout);
		tree_store_xkb_layouts = get_object<Gtk::TreeStore>(dbuilder, "tree-store-xkb-layouts");

		inputdevs =
		    gutil::list_box_reuser<input_device_row>(RESPREFIX "settings.glade", curr_devices, false);

		kblayouts =
		    gutil::list_box_reuser<kb_layout_row>(RESPREFIX "settings.glade", kb_layouts, false);

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
		settings->bind("kb-repeat-rate",
		               get_object<Gtk::Adjustment>(builder, "adj-repeat-rate")->property_value());
		settings->bind("kb-repeat-delay",
		               get_object<Gtk::Adjustment>(builder, "adj-repeat-delay")->property_value());

		wpsettings->signal_changed().connect([&](auto _) { on_new_settings(); });
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
			hdy_leaflet_set_visible_child_name(header_leaflet, "content");
			// XXX: clicking the already active row doesn't open content
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

		chooser_wp->signal_file_set().connect(
		    [&]() { wpsettings->set_string("picture-path", chooser_wp->get_filename()); });

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

		header_back->signal_clicked().connect(
		    [=] { hdy_leaflet_set_visible_child_name(header_leaflet, "sidebar"); });

		// xml builder supports bindings, but glade erases them on saving :(
		// https://source.puri.sm/Librem5/libhandy/issues/12 -- probably an issue about this
		g_object_bind_property(header_leaflet, "folded", header_back_revealer->gobj(), "reveal-child",
		                       static_cast<GBindingFlags>(G_BINDING_SYNC_CREATE));
		g_object_bind_property(header_leaflet, "folded", headerbar_sidebar->gobj(), "show-close-button",
		                       static_cast<GBindingFlags>(G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    header_leaflet, "visible-child-name", content_leaflet, "visible-child-name",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    header_leaflet, "mode-transition-duration", header_back_revealer->gobj(),
		    "transition-duration",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    header_leaflet, "child-transition-duration", content_leaflet, "child-transition-duration",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    header_leaflet, "child-transition-type", content_leaflet, "child-transition-type",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    header_leaflet, "mode-transition-duration", content_leaflet, "mode-transition-duration",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    header_leaflet, "mode-transition-type", content_leaflet, "mode-transition-type",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));

		window->reference();
	}

	void on_new_settings() {
		chooser_wp->select_filename(wpsettings->get_string("picture-path"));

		settings->get_value("xkb-layouts", xkb_layouts);
		kblayouts->ensure_row_count(xkb_layouts.get().size());
		size_t i = 0;
		for (auto &layout : xkb_layouts.get()) {
			auto &row = (*kblayouts)[i++];
			row.name->set_label(xkbdb.layouts[layout.first].desc);
			auto desc = xkbdb.layouts[layout.first].variants[layout.second];
			row.desc->set_label(desc.size() == 0 ? "Default Layout" : desc);
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
	hdy_init(&argc, &argv);
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
