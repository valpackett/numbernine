#include "surface.h"
#include <gtkmm.h>
#include <utility>

namespace lsh {

static void on_configure(void *data, struct zwlr_layer_surface_v1 * /*unused*/, uint32_t serial,
                         uint32_t width, uint32_t height) {
	auto *surf = reinterpret_cast<surface *>(data);
	Glib::signal_idle().connect([=] {
		surf->window->resize(width, height);
		return false;
	});
}

static void on_closed(void * /*unused*/, struct zwlr_layer_surface_v1 * /*unused*/) {}

static const struct zwlr_layer_surface_v1_listener surface_listener = {on_configure, on_closed};

anchor operator|(const anchor a, const anchor b) {
	return static_cast<anchor>(static_cast<int>(a) | static_cast<int>(b));
}

surface::surface(struct zwlr_layer_surface_v1 *s, std::shared_ptr<Gtk::Window> w)
    : lsurf(s), window(std::move(w)) {
	zwlr_layer_surface_v1_add_listener(lsurf, &surface_listener, this);
}

void surface::set_anchor(anchor anchor) {
	zwlr_layer_surface_v1_set_anchor(lsurf, static_cast<zwlr_layer_surface_v1_anchor>(anchor));
}

void surface::set_size(int32_t w, int32_t h) { zwlr_layer_surface_v1_set_size(lsurf, w, h); }

void surface::set_margin(int32_t top, int32_t right, int32_t bottom, int32_t left) {
	zwlr_layer_surface_v1_set_margin(lsurf, top, right, bottom, left);
}

}  // namespace lsh
