#pragma once
#include <gtkmm/window.h>
#include <cstdint>
#include <memory>
#include "wlr-input-inhibitor-unstable-v1-protocol.hpp"
#include "wlr-layer-shell-unstable-v1-protocol.hpp"

namespace lsh {

class surface;

class manager {
	wayland::zwlr_layer_shell_v1_t lshell;
	wayland::zwlr_input_inhibit_manager_v1_t inhib;

 public:
	// requires an existing Application just to ensure initialization has happened
	manager(Glib::RefPtr<Gtk::Application> &);

	std::optional<wayland::zwlr_input_inhibitor_v1_t> inhibit();

	friend class surface;
};

}  // namespace lsh
