#pragma once
#include <gtkmm.h>
#include <unordered_map>

class wpimage : public Gtk::DrawingArea {
	Glib::Property<Glib::ustring> _path;

 public:
	wpimage();
	Glib::PropertyProxy<Glib::ustring> property_path() { return _path.get_proxy(); }

 protected:
	bool on_draw(const Cairo::RefPtr<Cairo::Context>& cr) override;
};
