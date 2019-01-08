#pragma once
#include "widget.hpp"

class klock : public widget {
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::Label lbl;
	Glib::ustring fmt;
	sigc::connection timer;

	void tick();

 public:
	klock(const std::string &settings_key);
	Gtk::Widget &root() override { return lbl; }
	~klock() override;
};
