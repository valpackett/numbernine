#pragma once
#include <memory>
#include <optional>
#include <unordered_map>
#include "org.freedesktop.UPower.Device_proxy.h"
#include "org.freedesktop.UPower_proxy.h"
#include "widget.hpp"

class battery : public widget {
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::Box toplevel;
	std::optional<Glib::RefPtr<org::freedesktop::UPowerProxy>> electric_power;
	std::unordered_map<std::string, Glib::RefPtr<org::freedesktop::UPower::DeviceProxy>> devices;
	std::unordered_map<std::string, std::unique_ptr<Gtk::Image>> icons;
	std::unordered_map<std::string, std::unique_ptr<Gtk::Label>> percentages;
	std::unordered_map<std::string, std::unique_ptr<sigc::connection>> watches;
	sigc::connection watch_add;
	sigc::connection watch_remove;

	void tick();
	void make_widgets_for_device(const Glib::DBusObjectPathString &path);
	void on_add_device(const Glib::DBusObjectPathString &path);
	void on_remove_device(const Glib::DBusObjectPathString &path);

 public:
	battery(const std::string &settings_key);
	Gtk::Widget &root() override { return toplevel; }
};
