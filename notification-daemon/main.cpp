#include <gdk/gdkwayland.h>
#include <gtkmm.h>
#include <iostream>
#include <memory>
#include <vector>
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/surface.hpp"
#include "org.freedesktop.Notifications_stub.h"

#define RESPREFIX "/technology/unrelenting/numbernine/notification-daemon/"

std::shared_ptr<Gtk::Window> window;
Gtk::Box *box;

class notification {
	Glib::RefPtr<Gtk::Builder> builder =
	    Gtk::Builder::create_from_resource(RESPREFIX "notification.glade");
	Gtk::Grid *grid = nullptr;
	bool dead = false;

 public:
	notification(const Glib::ustring &title, const Glib::ustring &body,
	             const Glib::ustring &icon_name) {
		builder->get_widget<Gtk::Grid>("toplevel", grid);
		box->add(*grid);

		Gtk::Label *l_title = nullptr;
		builder->get_widget<Gtk::Label>("title", l_title);
		l_title->set_text(title);

		Gtk::Label *l_body = nullptr;
		builder->get_widget<Gtk::Label>("body", l_body);
		l_body->set_text(body);

		Gtk::Image *l_icon = nullptr;
		builder->get_widget<Gtk::Image>("icon", l_icon);
		l_icon->set_from_icon_name(icon_name, Gtk::ICON_SIZE_DIALOG);

		Gtk::Button *close = nullptr;
		builder->get_widget<Gtk::Button>("close", close);
		close->signal_clicked().connect([this] { die(); });

		grid->show_all();
	}

	void die() {
		if (dead) {
			return;
		}
		box->remove(*grid);
		dead = true;
		delete grid;
		// let the window recompute the height to fit the box
		window->set_size_request(480, 0);
		window->resize(480, 1);
	}
};

class bus_impl : public org::freedesktop::Notifications {
 public:
	void Notify(const Glib::ustring &app_name, guint32 replaces_id, const Glib::ustring &app_icon,
	            const Glib::ustring &summary, const Glib::ustring &body,
	            const std::vector<Glib::ustring> &actions,
	            const std::map<Glib::ustring, Glib::VariantBase> &hints, gint32 timeout,
	            NotificationsMessageHelper msg) override {
		Glib::signal_idle().connect([=] {
			new notification(summary, body, app_icon);
			return false;
		});
		msg.ret(1);
	}

	void CloseNotification(guint32 id, NotificationsMessageHelper msg) override { msg.ret(); }

	void GetCapabilities(NotificationsMessageHelper msg) override { msg.ret({"body"}); }

	void GetServerInformation(NotificationsMessageHelper msg) override {
		msg.ret("NumberNine", "unrelenting.technology", "0.0", "1.2");
	}
};

int main(int argc, char *argv[]) {
	auto app =
	    Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.notification-daemon");
	lsh::manager lsh_mgr(app);

	window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
	window->set_default_size(480, 0);
	window->set_decorated(false);
	lsh::surface window_lsh(lsh_mgr, window, lsh::layer::top);
	window_lsh.set_anchor(lsh::anchor::top | lsh::anchor::right);
	window_lsh.set_size(480, 1);
	window->show_all();
	window->set_app_paintable(true);

	auto css = Gtk::CssProvider::create();
	css->load_from_resource(RESPREFIX "style.css");
	window->get_style_context()->add_provider_for_screen(Gdk::Screen::get_default(), css,
	                                                     GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

	box = new Gtk::Box;
	box->set_orientation(Gtk::ORIENTATION_VERTICAL);
	box->set_valign(Gtk::ALIGN_START);
	box->set_hexpand(true);
	box->set_vexpand(false);
	box->show_all();
	window->add(*box);

	bus_impl bi;
	bi.connect(Gio::DBus::BUS_TYPE_SESSION, "org.freedesktop.Notifications");

	return app->run(*window);
}
