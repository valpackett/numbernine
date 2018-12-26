#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/multimonitor.hpp"
#include "gtk-lsh/surface.hpp"
#include "panel.hpp"

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.panel");
	lsh::manager lsh_mgr(app);
	lsh::multimonitor<panel, const std::string &, lsh::manager &> mm("default", lsh_mgr);
	app->hold();
	app->run();
}
