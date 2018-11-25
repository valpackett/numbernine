#pragma once
#include "widget.h"

class separator : public widget {
 public:
	separator(const std::string &settings_key);
	Gtk::Widget &root() override { return sep; }

 private:
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::Separator sep;
};
