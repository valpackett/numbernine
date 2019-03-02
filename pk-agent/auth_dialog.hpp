#pragma once

#include <gtkmm.h>
#include "auth_requester.hpp"
#include "gtk-lsh/surface.hpp"
#include "gtk-util/glade.hpp"

class auth_dialog {
	auth_requester *req;
	Glib::RefPtr<Gtk::Builder> builder = Gtk::Builder::create_from_resource(
	    "/technology/unrelenting/numbernine/pk-agent/"
	    "auth.glade");
	Gtk::EventBox wrapper;
	GLADE(Gtk::Box, toplevel);
	GLADE(Gtk::Label, message);
	GLADE(Gtk::Label, prompt);
	GLADE(Gtk::Label, identity);
	GLADE(Gtk::Entry, input);
	GLADE(Gtk::Button, deny);
	GLADE(Gtk::Button, allow);

 public:
	std::shared_ptr<Gtk::Window> window;
	std::optional<lsh::surface> layer_surface;

	auth_dialog(auth_requester *, lsh::manager &, Glib::ustring, GdkMonitor *);

	std::shared_ptr<Gtk::Window> get_window() const { return window; };

	~auth_dialog() = default;

	auth_dialog(auth_dialog &&) = delete;
};
