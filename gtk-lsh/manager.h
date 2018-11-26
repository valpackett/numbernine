#pragma once
#include <gtkmm/window.h>
#include <cstdint>
#include <memory>
#include "wlr-layer-shell-unstable-v1-client-protocol.h"

namespace lsh {

static void handle_global(void *, struct wl_registry *, uint32_t, const char *, uint32_t);

class surface;

class manager {
	struct zwlr_layer_shell_v1 *lshell = nullptr;

 public:
	// requires an existing Application just to ensure initialization has happened
	manager(Glib::RefPtr<Gtk::Application> &);

	friend void handle_global(void *, struct wl_registry *, uint32_t, const char *, uint32_t);
	friend class surface;
};

}  // namespace lsh
