#pragma once
#include "widget.h"

class separator : public widget {
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::Separator sep;

 public:
	separator(const std::string &settings_key);
	Gtk::Widget &root() override { return sep; }
};
