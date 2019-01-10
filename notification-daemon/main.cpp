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
	Gtk::Grid *grid = nullptr;
	bool dead = false;
	guint32 id;

 public:
	notification(guint32 id_, int position, const Glib::ustring &title, const Glib::ustring &body,
	             const Glib::ustring &icon_name)
	    : id(id_) {
		Glib::RefPtr<Gtk::Builder> builder =
		    Gtk::Builder::create_from_resource(RESPREFIX "notification.glade");

		builder->get_widget<Gtk::Grid>("toplevel", grid);
		grid->reference();
		box->add(*grid);
		box->reorder_child(*grid, position);

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

	guint32 get_id() { return id; }
	bool is_dead() { return dead; }

	int get_position() {
		if (dead) {
			return -1;
		}
		return box->child_property_position(*grid);
	}

	void die() {
		if (dead) {
			return;
		}
		dead = true;
		box->remove(*grid);
		delete grid;
		// let the window recompute the height to fit the box
		window->set_size_request(480, 0);
		window->resize(480, 1);
	}

	~notification() {
		if (!dead) {
			die();
		}
	}

	notification(notification &&) = delete;
};

std::vector<std::unique_ptr<notification>> notifications;
guint32 next_id = 0;

void cleanup_dead() {
	for (auto it = notifications.begin(); it != notifications.end();) {
		if ((*it)->is_dead()) {
			it = notifications.erase(it);
		} else {
			it++;
		}
	}
}

void remove_by_id(guint32 id) {
	for (auto it = notifications.begin(); it != notifications.end();) {
		if ((*it)->get_id() == id) {
			it = notifications.erase(it);
		} else {
			it++;
		}
	}
}

int position_of_id(guint32 id) {
	for (auto &notif : notifications) {
		if (notif->get_id() == id) {
			return notif->get_position();
		}
	}
	return -1;
}

class bus_impl : public org::freedesktop::Notifications {
 public:
	void Notify(const Glib::ustring &app_name, guint32 replaces_id, const Glib::ustring &app_icon,
	            const Glib::ustring &summary, const Glib::ustring &body,
	            const std::vector<Glib::ustring> &actions,
	            const std::map<Glib::ustring, Glib::VariantBase> &hints, gint32 timeout,
	            NotificationsMessageHelper msg) override {
		guint32 id = next_id;
		Glib::signal_idle().connect([=] {
			cleanup_dead();
			int pos = position_of_id(replaces_id);
			remove_by_id(replaces_id);
			notifications.push_back(std::make_unique<notification>(id, pos, summary, body, app_icon));
			if (timeout > 0) {
				Glib::signal_timeout().connect_once([=] { remove_by_id(id); }, timeout);
			}
			return false;
		});
		msg.ret(id);
		next_id++;
	}

	void CloseNotification(guint32 id, NotificationsMessageHelper msg) override {
		remove_by_id(id);
		msg.ret();
	}

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
	lsh::surface window_lsh(lsh_mgr, window, lsh::any_output, lsh::layer::top);
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
