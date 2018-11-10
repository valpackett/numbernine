#pragma once
#include <gtkmm/window.h>
#include <cstdint>
#include <memory>
#include "wlr-layer-shell-unstable-v1-client-protocol.h"

namespace lsh {

static void handle_global(void *, struct wl_registry *, uint32_t, const char *, uint32_t);

enum class layer {
	background = ZWLR_LAYER_SHELL_V1_LAYER_BACKGROUND,
	bottom = ZWLR_LAYER_SHELL_V1_LAYER_BOTTOM,
	top = ZWLR_LAYER_SHELL_V1_LAYER_TOP,
	overlay = ZWLR_LAYER_SHELL_V1_LAYER_OVERLAY,
};

static_assert(sizeof(layer) == sizeof(zwlr_layer_shell_v1_layer));

layer operator|(const layer a, const layer b);

class surface;

class manager {
	struct zwlr_layer_shell_v1 *lshell = nullptr;

 public:
	// requires an existing Application just to ensure initialization has happened
	manager(Glib::RefPtr<Gtk::Application> &);
	surface layerize(const std::shared_ptr<Gtk::Window> &, layer);

	friend void handle_global(void *, struct wl_registry *, uint32_t, const char *, uint32_t);
};

}  // namespace lsh
