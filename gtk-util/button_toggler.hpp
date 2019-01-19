#pragma once
#include <gtkmm.h>
#include <unordered_map>

namespace gutil {

class button_toggler : public Gtk::Box {
	size_t count = 0;
	size_t sel_idx = 0;

 public:
	button_toggler(BaseObjectType* cobject, const Glib::RefPtr<Gtk::Builder>& builder);

	void append(Glib::RefPtr<Gtk::ToggleButton> butt);
	void select_by_index(size_t idx);
	void clear();
};

}  // namespace gutil
