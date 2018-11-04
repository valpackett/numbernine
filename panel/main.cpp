#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <memory>
#include "gtk-lsh/manager.h"
#include "gtk-lsh/surface.h"

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.panel");
	lsh::manager lsh_mgr(app);

	auto window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
	window->set_default_size(200, 24);
	window->set_decorated(false);
	auto window_lsh = lsh_mgr.layerize(window, lsh::layer::top);
	window_lsh.set_anchor(lsh::anchor::left | lsh::anchor::bottom | lsh::anchor::right);
	window_lsh.set_size(640, 24);
	window->show_all();

	return app->run(*window);
}
