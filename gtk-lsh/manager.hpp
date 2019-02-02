#pragma once
#include <gtkmm/window.h>
#include <cstdint>
#include <memory>
#include "wlr-layer-shell-unstable-v1-protocol.hpp"

namespace lsh {

class surface;

class manager {
	wayland::zwlr_layer_shell_v1_t lshell;

 public:
	// requires an existing Application just to ensure initialization has happened
	manager(Glib::RefPtr<Gtk::Application> &);

	friend class surface;
};

}  // namespace lsh
