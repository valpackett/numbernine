#pragma once
#include "widget.hpp"

class remoteaction : public widget {
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::Button termbtn;

 public:
	remoteaction(const std::string &settings_key);
	Gtk::Widget &root() override { return termbtn; }
};
