#pragma once
#include "widget.h"

class quicklaunch : public widget {
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::Button termbtn;

 public:
	quicklaunch(const std::string &settings_key);
	Gtk::Widget &root() override { return termbtn; }
};
