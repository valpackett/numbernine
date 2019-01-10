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
	sigc::signal<void, guint32, guint32> *closed_signal = nullptr;
	sigc::signal<void, guint32, Glib::ustring> *invoked_signal = nullptr;
	Gtk::EventBox *topl = nullptr;
	bool dead = false;
	guint32 id;

 public:
	notification(guint32 id_, int position, int urgency, const Glib::ustring &title,
	             const Glib::ustring &body, const Glib::ustring &icon_name,
	             const std::vector<Glib::ustring> &actions,
	             sigc::signal<void, guint32, guint32> *closed_,
	             sigc::signal<void, guint32, Glib::ustring> *invoked_)
	    : id(id_), closed_signal(closed_), invoked_signal(invoked_) {
		Glib::RefPtr<Gtk::Builder> builder =
		    Gtk::Builder::create_from_resource(RESPREFIX "notification.glade");

		builder->get_widget("toplevel", topl);
		topl->reference();
		box->add(*topl);
		box->reorder_child(*topl, position);

		Gtk::Label *l_title = nullptr;
		builder->get_widget("title", l_title);
		l_title->set_text(title);

		Gtk::Label *l_body = nullptr;
		builder->get_widget("body", l_body);
		l_body->set_markup(body);

		Gtk::Image *l_icon = nullptr;
		builder->get_widget("icon", l_icon);
		l_icon->set_from_icon_name(icon_name, Gtk::ICON_SIZE_DIALOG);

		Gtk::Button *close = nullptr;
		builder->get_widget("close", close);
		close->signal_clicked().connect([this] { die(2); });

		Gtk::ButtonBox *btns = nullptr;
		builder->get_widget("btns", btns);
		for (auto it = actions.begin(); it != actions.end() && it + 1 != actions.end(); it += 2) {
			auto *action_btn = new Gtk::Button;
			action_btn->set_label(*(it + 1));
			auto action = *it;
			action_btn->signal_clicked().connect([=] { invoked_signal->emit(id, action); });
			btns->add(*action_btn);
		}

		Gtk::Grid *grid = nullptr;
		builder->get_widget("grid", grid);
		grid->get_style_context()->add_class("n9-nd-urgency-" + std::to_string(urgency));

		topl->set_events(Gdk::BUTTON_PRESS_MASK);
		topl->signal_button_press_event().connect([this](GdkEventButton *evt) {
			invoked_signal->emit(id, "default");
			die(4);
			return true;
		});
		topl->show_all();
	}

	guint32 get_id() { return id; }
	bool is_dead() { return dead; }

	int get_position() {
		if (dead) {
			return -1;
		}
		return box->child_property_position(*topl);
	}

	void die(guint32 reason) {
		if (dead) {
			return;
		}
		dead = true;
		box->remove(*topl);
		delete topl;
		// let the window recompute the height to fit the box
		window->set_size_request(480, 0);
		window->resize(480, 1);
		closed_signal->emit(id, reason);
	}

	~notification() {
		if (!dead) {
			die(4);
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

void remove_by_id(guint32 id, guint32 reason) {
	for (auto it = notifications.begin(); it != notifications.end();) {
		if ((*it)->get_id() == id) {
			(*it)->die(reason);
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
		int urgency =
		    hints.count("urgency") != 0
		        ? Glib::Variant<guint8>::cast_dynamic<Glib::Variant<guint8>>(hints.at("urgency")).get()
		        : 0;
		Glib::signal_idle().connect([=] {
			cleanup_dead();
			int pos = position_of_id(replaces_id);
			remove_by_id(replaces_id, 4);
			notifications.push_back(
			    std::make_unique<notification>(id, pos, urgency, summary, body, app_icon, actions,
			                                   &NotificationClosed_signal, &ActionInvoked_signal));
			if (timeout != 0 && urgency != 2) {
				Glib::signal_timeout().connect_once([=] { remove_by_id(id, 1); },
				                                    timeout == -1 ? 2000 : timeout);
			}
			return false;
		});
		msg.ret(id);
		next_id++;
	}

	void CloseNotification(guint32 id, NotificationsMessageHelper msg) override {
		remove_by_id(id, 3);
		msg.ret();
	}

	void GetCapabilities(NotificationsMessageHelper msg) override {
		msg.ret({"actions", "body", "body-markup", "body-hyperlinks"});
	}

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
