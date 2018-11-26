#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <iostream>
#include <memory>
#include "gtk-lsh/manager.h"
#include "gtk-lsh/surface.h"
#include "panel.h"
#include "widgets.h"

std::unordered_map<std::string, std::unique_ptr<widget>> widgets;

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.panel");
	lsh::manager lsh_mgr(app);
	panel default_panel("default", lsh_mgr);
	return app->run(*default_panel.get_window());
}
