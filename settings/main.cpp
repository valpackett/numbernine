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
#include "gtk-util/glade.hpp"
#include "gtk-util/list_box_reuser.hpp"
#include "xkb.hpp"

#define RESPREFIX "/technology/unrelenting/numbernine/settings/"

using Glib::RefPtr, Glib::Variant;
using std::vector, std::tuple, std::pair, std::string;

struct input_device_row {
	RefPtr<Gtk::Builder> builder;
	GLADE(Gtk::Grid, row_input_device);
	GLADE(Gtk::Label, input_device_name);
	GLADE(Gtk::Label, input_device_description);
	GLADE(Gtk::Image, input_device_icon);

	input_device_row(RefPtr<Gtk::Builder> &_builder) : builder(_builder) {}

	void on_added() {
		row_input_device->get_parent()->get_style_context()->add_class("n9-settings-row");
	}

	Gtk::Grid *toplevel() { return row_input_device; }
};

struct kb_layout_row {
	RefPtr<Gtk::Builder> builder;
	GLADE(Gtk::Grid, row_kb_layout);
	GLADE(Gtk::Label, kb_layout_name);
	GLADE(Gtk::Label, kb_layout_description);

	kb_layout_row(RefPtr<Gtk::Builder> &_builder) : builder(_builder) {}

	void on_added() {
		row_kb_layout->get_parent()->get_style_context()->add_class("n9-settings-row");
	}

	Gtk::Grid *toplevel() { return row_kb_layout; }
};

struct settings_app {
	xkbdb xkbdb;
	Variant<vector<pair<string, string>>> xsa_keyboard_layouts_list;

	RefPtr<Gio::Settings> settings =
	                          Gio::Settings::create("technology.unrelenting.numbernine.settings",
	                                                "/technology/unrelenting/numbernine/settings/"),
	                      wpsettings =
	                          Gio::Settings::create("technology.unrelenting.numbernine.wallpaper",
	                                                "/technology/unrelenting/numbernine/wallpaper/");

	RefPtr<Gtk::Builder> builder = Gtk::Builder::create_from_resource(RESPREFIX "settings.glade"),
	                     dbuilder = Gtk::Builder::create_from_resource(RESPREFIX "dialogs.glade");

	GLADE(Gtk::ApplicationWindow, sa_toplevel);

	// Header
	GLADE(Gtk::Button, sa_header_back);
	GLADE(Gtk::Revealer, sa_header_back_revealer);
	GLADE_GOBJ(HdyLeaflet, HDY_LEAFLET, sa_header_leaflet);
	GLADE(Gtk::HeaderBar, sa_header_bar_main);
	GLADE(Gtk::HeaderBar, sa_header_bar_sidebar);

	// Window content
	GLADE_GOBJ(HdyLeaflet, HDY_LEAFLET, sa_top_leaflet);
	GLADE(Gtk::StackSidebar, sa_top_stack_sidebar);
	GLADE(Gtk::Stack, sa_top_stack);

	// Tab: Appearance
	GLADE(Gtk::FileChooserButton, sa_appear_wp_picture_chooser);

	// Tab: Mouse and Touchpad
	GLADE(Gtk::ListBox, sa_input_current_devices_list);
	gutil::list_box_reuser<input_device_row> inputdevs{RESPREFIX "settings.glade",
	                                                   sa_input_current_devices_list, false};

	// Tab: Keyboard
	GLADE(Gtk::ListBox, sa_keyboard_layouts_list);
	gutil::list_box_reuser<kb_layout_row> kblayouts{RESPREFIX "settings.glade",
	                                                sa_keyboard_layouts_list, false};

	// Tab: Display
	GLADE_DERIVED(gutil::button_toggler, sa_display_output_toggler);

	// Dialog: New keyboard layout
	GLADEB(dbuilder, Gtk::Dialog, dialog_add_keyboard_layout);
	GLADEB(dbuilder, Gtk::TreeView, tree_add_keyboard_layout);
	GLADEB_OBJ(dbuilder, Gtk::TreeStore, tree_store_xkb_layouts);

	settings_app() {
		settings->bind(
		    "mice-accel-speed",
		    gutil::get_object<Gtk::Adjustment>(builder, "adj-mouse-speed")->property_value());
		settings->bind(
		    "mice-scroll-speed",
		    gutil::get_object<Gtk::Adjustment>(builder, "adj-mouse-scroll-speed")->property_value());
		settings->bind(
		    "touchpads-accel-speed",
		    gutil::get_object<Gtk::Adjustment>(builder, "adj-touchpad-speed")->property_value());
		settings->bind(
		    "touchpads-scroll-speed",
		    gutil::get_object<Gtk::Adjustment>(builder, "adj-touchpad-scroll-speed")->property_value());
		settings->bind(
		    "touchpads-natural-scrolling",
		    gutil::get_widget<Gtk::Switch>(builder, "toggle-natural-scrolling")->property_active());
		settings->bind("touchpads-tap-click",
		               gutil::get_widget<Gtk::Switch>(builder, "toggle-tap-click")->property_active());
		settings->bind(
		    "touchpads-click-method",
		    gutil::get_widget<Gtk::ComboBoxText>(builder, "choose-click-method")->property_active_id());
		settings->bind("touchpads-scroll-method",
		               gutil::get_widget<Gtk::ComboBoxText>(builder, "choose-scroll-method")
		                   ->property_active_id());
		settings->bind(
		    "touchpads-dwt",
		    gutil::get_widget<Gtk::Switch>(builder, "toggle-touchpad-dwt")->property_active());
		settings->bind("touchpads-dwmouse",
		               gutil::get_widget<Gtk::Switch>(builder, "toggle-dwmouse")->property_active());
		settings->bind(
		    "kb-repeat-rate",
		    gutil::get_object<Gtk::Adjustment>(builder, "adj-repeat-rate")->property_value());
		settings->bind(
		    "kb-repeat-delay",
		    gutil::get_object<Gtk::Adjustment>(builder, "adj-repeat-delay")->property_value());
		settings->bind(
		    "m2k-ctrl-as-esc",
		    gutil::get_widget<Gtk::Switch>(builder, "toggle-ctrl-as-esc")->property_active());
		settings->bind(
		    "m2k-shifts-as-parens",
		    gutil::get_widget<Gtk::Switch>(builder, "toggle-shifts-as-parens")->property_active());

		wpsettings->signal_changed().connect([&](auto _) { on_new_settings(); });
		settings->signal_changed().connect([&](auto _) { on_new_settings(); });
		on_new_settings();

		auto css = Gtk::CssProvider::create();
		css->load_from_resource(RESPREFIX "style.css");
		sa_toplevel->get_style_context()->add_provider_for_screen(
		    Gdk::Screen::get_default(), css, GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

		auto update_title = [=] {
			sa_header_bar_main->set_title(
			    sa_top_stack->child_property_title(*sa_top_stack->property_visible_child().get_value())
			        .get_value());
			hdy_leaflet_set_visible_child_name(sa_header_leaflet, "content");
			// XXX: clicking the already active row doesn't open content
		};
		update_title();
		sa_top_stack->property_visible_child().signal_changed().connect(update_title);

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

		sa_appear_wp_picture_chooser->signal_file_set().connect([&]() {
			wpsettings->set_string("picture-path", sa_appear_wp_picture_chooser->get_filename());
		});

		sa_toplevel->add_action("add-keyboard-layout", [&]() {
			dialog_add_keyboard_layout->set_transient_for(*sa_toplevel);
			if (dialog_add_keyboard_layout->run() == Gtk::RESPONSE_OK) {
				string layout, variant;
				tree_add_keyboard_layout->get_selection()->get_selected()->get_value(2, layout);
				tree_add_keyboard_layout->get_selection()->get_selected()->get_value(3, variant);
				vector<tuple<Glib::ustring, Glib::ustring>> v;
				for (const auto &p : xsa_keyboard_layouts_list.get()) {
					v.emplace_back(p.first, p.second);
				}
				v.emplace_back(layout, variant);
				settings->set_value("xkb-layouts",
				                    Variant<vector<tuple<Glib::ustring, Glib::ustring>>>::create(v));
			}
			dialog_add_keyboard_layout->hide();
		});

		sa_toplevel->add_action("remove-keyboard-layout", [&]() {
			if (sa_keyboard_layouts_list->get_selected_row() == nullptr) {
				return;
			}
			auto idx = sa_keyboard_layouts_list->get_selected_row()->get_index();
			int i = 0;
			vector<tuple<Glib::ustring, Glib::ustring>> v;
			for (const auto &p : xsa_keyboard_layouts_list.get()) {
				if (i != idx) {
					v.emplace_back(p.first, p.second);
				}
				i++;
			}
			settings->set_value("xkb-layouts",
			                    Variant<vector<tuple<Glib::ustring, Glib::ustring>>>::create(v));
			// TODO notification bar with undo
		});

		sa_header_back->signal_clicked().connect(
		    [=] { hdy_leaflet_set_visible_child_name(sa_header_leaflet, "sidebar"); });

		// xml builder supports bindings, but glade erases them on saving :(
		// https://source.puri.sm/Librem5/libhandy/issues/12 -- probably an issue about this
		g_object_bind_property(sa_header_leaflet, "folded", sa_header_back_revealer->gobj(),
		                       "reveal-child", static_cast<GBindingFlags>(G_BINDING_SYNC_CREATE));
		g_object_bind_property(sa_header_leaflet, "folded", sa_header_bar_sidebar->gobj(),
		                       "show-close-button", static_cast<GBindingFlags>(G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    sa_header_leaflet, "visible-child-name", sa_top_leaflet, "visible-child-name",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    sa_header_leaflet, "mode-transition-duration", sa_header_back_revealer->gobj(),
		    "transition-duration",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    sa_header_leaflet, "child-transition-duration", sa_top_leaflet, "child-transition-duration",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    sa_header_leaflet, "child-transition-type", sa_top_leaflet, "child-transition-type",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    sa_header_leaflet, "mode-transition-duration", sa_top_leaflet, "mode-transition-duration",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));
		g_object_bind_property(
		    sa_header_leaflet, "mode-transition-type", sa_top_leaflet, "mode-transition-type",
		    static_cast<GBindingFlags>(G_BINDING_BIDIRECTIONAL | G_BINDING_SYNC_CREATE));

		// sa_toplevel->reference();
	}

	void on_new_settings() {
		sa_appear_wp_picture_chooser->select_filename(wpsettings->get_string("picture-path"));

		settings->get_value("xkb-layouts", xsa_keyboard_layouts_list);
		kblayouts.ensure_row_count(xsa_keyboard_layouts_list.get().size());
		size_t i = 0;
		for (auto &layout : xsa_keyboard_layouts_list.get()) {
			auto &row = kblayouts[i++];
			row.kb_layout_name->set_label(xkbdb.layouts[layout.first].desc);
			auto desc = xkbdb.layouts[layout.first].variants[layout.second];
			row.kb_layout_description->set_label(desc.empty() ? "Default Layout" : desc);
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
				string desc = fmt::format(_("Vendor ID: {:#06x}, product ID: {:#06x}.\n"),
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

		sa_display_output_toggler->clear();
		for (const auto output : *state->outputs()) {
			RefPtr<Gtk::ToggleButton> btn(new Gtk::ToggleButton);
			btn->set_label(output->name()->str());
			sa_display_output_toggler->append(btn);
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

	app->run(*sapp.sa_toplevel);
}
