#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <iostream>
#include <memory>
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/surface.hpp"
#include "panel.hpp"

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.panel");
	lsh::manager lsh_mgr(app);
	panel default_panel("default", lsh_mgr);
	return app->run(*default_panel.get_window());
}
