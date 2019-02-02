#include "surface.hpp"
#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <utility>

namespace lsh {

using namespace wayland;

surface::surface(manager &mgr, std::shared_ptr<Gtk::Window> w,
                 std::variant<any_output_t, wl_output *, GdkMonitor *> output,
                 zwlr_layer_shell_v1_layer layer)
    : window(std::move(w)) {
	gtk_widget_realize(reinterpret_cast<GtkWidget *>(window->gobj()));
	auto *gdwnd = window->get_window()->gobj();
	gdk_wayland_window_set_use_custom_surface(gdwnd);
	surface_t wlsurf{gdk_wayland_window_get_wl_surface(gdwnd), proxy_t::wrapper_type::foreign};
	wl_output *outputptr = nullptr;
	if (std::holds_alternative<wl_output *>(output)) {
		outputptr = std::get<wl_output *>(output);
	} else if (std::holds_alternative<GdkMonitor *>(output)) {
		outputptr = gdk_wayland_monitor_get_wl_output(std::get<GdkMonitor *>(output));
	}
	lsurf = mgr.lshell.get_layer_surface(wlsurf, outputptr, layer, "test");
	lsurf.on_closed() = [=]() {
		Glib::signal_idle().connect([=] {
			if (on_closed) {
				on_closed(window);
			} else {
				window->close();
			}
			return false;
		});
	};
	lsurf.on_configure() = [=](uint32_t serial, uint32_t width, uint32_t height) {
		Glib::signal_idle().connect([=] {
			window->show();
			if (width > 0 && height > 0) {
				window->resize(width, height);
			}
			lsurf.ack_configure(serial);
			return false;
		});
	};
	wlsurf.commit();
}

}  // namespace lsh
