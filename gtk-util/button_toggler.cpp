#include "button_toggler.hpp"

gutil::button_toggler::button_toggler(BaseObjectType *cobject,
                                      const Glib::RefPtr<Gtk::Builder> &builder)
    : Gtk::Box(cobject) {
	set_can_focus(false);
	set_homogeneous(true);
}

void gutil::button_toggler::append(Glib::RefPtr<Gtk::ToggleButton> butt) {
	add(*butt.get());
	size_t idx = count;
	butt->signal_toggled().connect([=] {
		butt->reference();
		if (butt->get_active()) {
			select_by_index(idx);
		} else if (sel_idx == idx) {
			butt->set_active(true);
		}
	});
	count++;
}

void gutil::button_toggler::select_by_index(size_t idx) {
	size_t i = 0;
	sel_idx = idx;
	for (auto &c : get_children()) {
		Glib::RefPtr<Gtk::ToggleButton>::cast_static(Glib::RefPtr<Gtk::Widget>(c))
		    ->set_active(i++ == idx);
	}
}

void gutil::button_toggler::clear() {
	count = 0;
	sel_idx = 0;
	for (auto &c : get_children()) {
		remove(*c);
	}
}
