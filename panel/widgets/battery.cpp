#include "battery.hpp"
#include <fmt/format.h>

using lol::org::freedesktop::UPower::Device;
using org::freedesktop::UPower;

typedef enum {
	UP_DEVICE_KIND_UNKNOWN,
	UP_DEVICE_KIND_LINE_POWER,
	UP_DEVICE_KIND_BATTERY,
	UP_DEVICE_KIND_UPS,
	UP_DEVICE_KIND_MONITOR,
	UP_DEVICE_KIND_MOUSE,
	UP_DEVICE_KIND_KEYBOARD,
	UP_DEVICE_KIND_PDA,
	UP_DEVICE_KIND_PHONE,
	UP_DEVICE_KIND_MEDIA_PLAYER,
	UP_DEVICE_KIND_TABLET,
	UP_DEVICE_KIND_COMPUTER,
	UP_DEVICE_KIND_GAMING_INPUT,
	UP_DEVICE_KIND_LAST
} UpDeviceKind;

battery::battery(const std::string &settings_key) {
	settings =
	    Gio::Settings::create(GSNAMEPREFIX "widgets.battery", GSPATHPREFIX + settings_key + "/");

	auto css = toplevel.get_style_context();
	css->add_class("n9-panel-widget");
	css->add_class("n9-panel-battery");

	toplevel.show_all();

	UPower::createForBus(
	    Gio::DBus::BUS_TYPE_SYSTEM, Gio::DBus::PROXY_FLAGS_DO_NOT_LOAD_PROPERTIES,
	    "org.freedesktop.UPower", "/org/freedesktop/UPower",
	    [=](Glib::RefPtr<Gio::AsyncResult> result) {
		    electric_power = UPower::createForBusFinish(std::move(result));
		    watch_add = (*electric_power)
		                    ->DeviceAdded_signal.connect(sigc::mem_fun(*this, &battery::on_add_device));
		    watch_remove =
		        (*electric_power)
		            ->DeviceRemoved_signal.connect(sigc::mem_fun(*this, &battery::on_remove_device));
		    (*electric_power)->EnumerateDevices([=](auto res) {
			    std::vector<Glib::DBusObjectPathString> paths;
			    (*electric_power)->EnumerateDevices_finish(paths, res);
			    for (const auto &p : paths) {
				    on_add_device(p);
			    }
		    });
	    });
}

void battery::tick() {
	for (const auto &[path, dev] : devices) {
		if (icons.find(path) != icons.end()) {
			fmt::print(stderr, "{} {}\n", path.c_str(), dev->IconName_get().c_str());
			icons[path]->set_from_icon_name(dev->IconName_get() + "-symbolic",
			                                Gtk::ICON_SIZE_SMALL_TOOLBAR);
			percentages[path]->set_text(fmt::format("{:.0f}%", dev->Percentage_get()));
		}
	}
}

void battery::make_widgets_for_device(const Glib::DBusObjectPathString &path) {
	auto kind = devices[path]->Type_get();
	if (!(kind == UP_DEVICE_KIND_BATTERY || kind == UP_DEVICE_KIND_UPS)) {
		return;
	}

	icons.emplace(path, new Gtk::Image);
	toplevel.add(*icons[path]);
	icons[path]->show();

	percentages.emplace(path, new Gtk::Label);
	toplevel.add(*percentages[path]);
	percentages[path]->show();
	settings->bind("percent", percentages[path]->property_visible());
}

void battery::on_add_device(const Glib::DBusObjectPathString &path) {
	if (!electric_power) {
		return;
	}
	Device::createForBus(Gio::DBus::BUS_TYPE_SYSTEM, Gio::DBus::PROXY_FLAGS_NONE,
	                     "org.freedesktop.UPower", path, [=](Glib::RefPtr<Gio::AsyncResult> result) {
		                     devices.emplace(path, Device::createForBusFinish(std::move(result)));
		                     make_widgets_for_device(path);
		                     auto conn =
		                         devices[path]->dbusProxy()->signal_properties_changed().connect(
		                             [=](auto /* unused */, auto /* unused */) { tick(); });
		                     watches.emplace(path, std::make_unique<sigc::connection>(conn));
		                     tick();
	                     });
}

void battery::on_remove_device(const Glib::DBusObjectPathString &path) {
	watches.erase(path);
	devices.erase(path);
	icons.erase(path);
	percentages.erase(path);
}
