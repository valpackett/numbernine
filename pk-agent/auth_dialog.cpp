#include "auth_dialog.hpp"
#include <fmt/core.h>
#define RESPREFIX "/technology/unrelenting/numbernine/pk-agent/"

auth_dialog::auth_dialog(auth_requester *r, lsh::manager &lsh_mgr, Glib::ustring prompt_str,
                         GdkMonitor *monitor)
    : req(r) {
	window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
	window->set_decorated(false);
	window->set_app_paintable(true);
	layer_surface.emplace(lsh_mgr, window, monitor, lsh::layer::overlay);
	(*layer_surface)
	    ->set_anchor(lsh::anchor::top | lsh::anchor::left | lsh::anchor::bottom | lsh::anchor::right);
	(*layer_surface)->set_size(0, 0);
	(*layer_surface)->set_keyboard_interactivity(1u);

	auto css = Gtk::CssProvider::create();
	css->load_from_resource(RESPREFIX "style.css");
	window->get_style_context()->add_provider_for_screen(Gdk::Screen::get_default(), css,
	                                                     GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

	wrapper.get_style_context()->add_class("n9-polkit-transparent-wrapper");
	wrapper.set_above_child(false);

	toplevel->set_valign(Gtk::Align::ALIGN_CENTER);
	toplevel->set_halign(Gtk::Align::ALIGN_CENTER);

	prompt->set_text(prompt_str);
	message->set_text(r->get_message());
	identity->set_text(r->get_user());

	deny->signal_clicked().connect([=]() {
		r->cancel_auth();
		// completed callback will close the window
	});

	allow->signal_clicked().connect([this]() {
		auto t = input->get_text();
		req->on_response(t);
	});

	input->signal_key_release_event().connect([&](GdkEventKey *evt) {
		if (evt->keyval == GDK_KEY_Return || evt->keyval == GDK_KEY_KP_Enter ||
		    evt->keyval == GDK_KEY_ISO_Enter) {
			auto t = input->get_text();
			req->on_response(t);
			return true;
		}
		return false;
	});

	req->add_completed_callback([this](bool) { window->close(); });

	wrapper.add(*toplevel);
	wrapper.show_all();
	window->add(wrapper);
}
