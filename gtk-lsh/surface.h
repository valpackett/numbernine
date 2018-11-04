#pragma once
#include <gtkmm/window.h>
#include <cstdint>
#include <memory>
#include "manager.h"
#include "wlr-layer-shell-unstable-v1-client-protocol.h"

namespace lsh {

static void on_configure(void *, struct zwlr_layer_surface_v1 *, uint32_t, uint32_t, uint32_t);

enum class anchor {
	top = ZWLR_LAYER_SURFACE_V1_ANCHOR_TOP,
	bottom = ZWLR_LAYER_SURFACE_V1_ANCHOR_BOTTOM,
	left = ZWLR_LAYER_SURFACE_V1_ANCHOR_LEFT,
	right = ZWLR_LAYER_SURFACE_V1_ANCHOR_RIGHT,
};

static_assert(sizeof(anchor) == sizeof(zwlr_layer_surface_v1_anchor));

anchor operator|(const anchor a, const anchor b);

class surface {
	struct zwlr_layer_surface_v1 *lsurf = nullptr;
	std::shared_ptr<Gtk::Window> window;

	surface(struct zwlr_layer_surface_v1 *, std::shared_ptr<Gtk::Window>);

 public:
	void set_anchor(anchor);
	void set_size(int32_t, int32_t);
	void set_margin(int32_t top, int32_t right, int32_t bottom, int32_t left);

	friend class manager;
	friend void on_configure(void *, struct zwlr_layer_surface_v1 *, uint32_t, uint32_t, uint32_t);
};

}  // namespace lsh
