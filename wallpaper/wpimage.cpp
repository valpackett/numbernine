#include "wpimage.hpp"

wpimage::wpimage()
    : Glib::ObjectBase(typeid(wpimage)), Gtk::DrawingArea(), _path(*this, "path", "/dev/null") {
	_path.get_proxy().signal_changed().connect([this] {
		auto win = get_window();
		if (win) {
			Gdk::Rectangle r(0, 0, get_allocation().get_width(), get_allocation().get_height());
			win->invalidate_rect(r, false);
		}
	});
}

// To avoid wasting memory, the image is decoded in the draw call.
// The surface will be redrawn.. pretty much never.

bool wpimage::on_draw(const Cairo::RefPtr<Cairo::Context> &cr) {
	auto alloc = get_allocation();
	auto scale = get_scale_factor();
	auto pbuf = Gdk::Pixbuf::create_from_file(_path.get_value());
	auto surf = Cairo::RefPtr(new Cairo::Surface(
	    gdk_cairo_surface_create_from_pixbuf(pbuf->gobj(), scale, get_window()->gobj())));
	cr->set_source(surf, (alloc.get_width() - pbuf->get_width() / scale) / 2,
	               (alloc.get_height() - pbuf->get_height() / scale) / 2);
	cr->paint();
	surf->unreference();
	pbuf->unreference();
	return true;
}
