#pragma once
#include <gtkmm/window.h>
#include <memory>
#include <variant>
#include "manager.hpp"
#include "wlr-layer-shell-unstable-v1-protocol.hpp"

namespace lsh {

using layer = wayland::zwlr_layer_shell_v1_layer;
using anchor = wayland::zwlr_layer_surface_v1_anchor;

struct any_output_t {};
const any_output_t any_output;

class surface {
	wayland::surface_t wlsurf;
	wayland::zwlr_layer_surface_v1_t lsurf;
	std::shared_ptr<Gtk::Window> window;
	std::function<void(std::shared_ptr<Gtk::Window>)> on_closed;

 public:
	surface(manager &mgr, std::shared_ptr<Gtk::Window> w,
	        std::variant<any_output_t, wl_output *, GdkMonitor *> output, layer layer);

	void set_on_closed(std::function<void(std::shared_ptr<Gtk::Window>)> cb) { on_closed = cb; }

	wayland::zwlr_layer_surface_v1_t *operator->() { return &lsurf; }

	friend class manager;

	surface(surface &&) = delete;
};

}  // namespace lsh
