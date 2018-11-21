#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <iostream>
#include <memory>
#include <unordered_map>
#include "gtk-lsh/manager.h"
#include "gtk-lsh/surface.h"

#define GSNAMEPREFIX "technology.unrelenting.numbernine.panel."
#define GSPATHPREFIX "/technology/unrelenting/numbernine/panel/"

class widget {
 public:
	virtual Gtk::Widget &root() = 0;
	virtual ~widget() = default;
};

class quicklaunch : public widget {
 public:
	quicklaunch(const std::string &settings_key) {
		settings = Gio::Settings::create(GSNAMEPREFIX "widgets.quicklaunch",
		                                 GSPATHPREFIX "default/" + settings_key + "/");
		termbtn.set_image_from_icon_name(settings->get_string("icon-name"));
		std::cout << settings->get_string("icon-name") << std::endl;
		termbtn.signal_clicked().connect([] {
			std::string apppath = "/usr/local/bin/gnome-terminal";
			std::vector argv({apppath});
			Glib::spawn_async(Glib::getenv("HOME"), argv);
		});
		termbtn.show_all();
	}

	Gtk::Widget &root() override { return termbtn; }

 private:
	Glib::RefPtr<Gio::Settings> settings;
	Gtk::Button termbtn;
};

std::unique_ptr<widget> make_widget(const std::string &widget_name, std::string settings_key) {
	if (widget_name == ".quicklaunch") {
		return std::make_unique<quicklaunch>(settings_key);
	}
}

std::unordered_map<std::string, std::unique_ptr<widget>> widgets;

int main(int argc, char *argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.panel");
	lsh::manager lsh_mgr(app);

	auto window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
	window->set_default_size(200, 24);
	window->set_decorated(false);
	auto window_lsh = lsh_mgr.layerize(window, lsh::layer::top);
	window_lsh.set_anchor(lsh::anchor::left | lsh::anchor::bottom | lsh::anchor::right);
	window_lsh.set_size(640, 24);

	Gtk::Box widgetbox;

	auto default_settings = Gio::Settings::create(GSNAMEPREFIX "panel", GSPATHPREFIX "default/");
	Glib::Variant<std::vector<std::pair<Glib::ustring, Glib::ustring>>> widget_conf_list;
	default_settings->get_value("widgets", widget_conf_list);
	for (auto widget_conf : widget_conf_list.get()) {
		widgets.emplace(widget_conf.second, make_widget(widget_conf.first, widget_conf.second));
		widgetbox.add(widgets[widget_conf.second]->root());
	}

	window->add(widgetbox);
	window->show_all();
	return app->run(*window);
}
