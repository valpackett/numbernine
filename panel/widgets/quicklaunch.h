#pragma once
#include "widget.h"

class quicklaunch : public widget {
 public:
	quicklaunch(const std::string &settings_key);
	Gtk::Widget &root() override { return termbtn; }

 private:
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::Button termbtn;
};
