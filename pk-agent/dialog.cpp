#define POLKIT_AGENT_I_KNOW_API_IS_SUBJECT_TO_CHANGE
#include <fmt/core.h>
#include <gtkmm.h>
#include <polkitagent/polkitagent.h>
#include <sys/mman.h>
#include <cstdlib>
#include <cstring>
#include "PkAgent_generated.h"
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/multimonitor.hpp"
#include "gtk-lsh/surface.hpp"
#include "gtk-util/glade.hpp"
#include "shared_util.hpp"
#define RESPREFIX "/technology/unrelenting/numbernine/pk-agent/"

PolkitAgentSession *session = nullptr;
void *auth_req_buf = nullptr;
size_t auth_req_buf_len = 0;
const n9::AuthRequest *auth_req = nullptr;

struct dialog {
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

	std::shared_ptr<Gtk::Window> window;
	std::optional<lsh::surface> layer_surface;

	dialog(lsh::manager &lsh_mgr, const Glib::ustring &prompt_str, GdkMonitor *monitor) {
		window = std::make_shared<Gtk::Window>(Gtk::WINDOW_TOPLEVEL);
		window->set_decorated(false);
		window->set_app_paintable(true);
		layer_surface.emplace(lsh_mgr, window, monitor, lsh::layer::overlay);
		(*layer_surface)
		    ->set_anchor(lsh::anchor::top | lsh::anchor::left | lsh::anchor::bottom |
		                 lsh::anchor::right);
		(*layer_surface)->set_size(0, 0);
		(*layer_surface)->set_keyboard_interactivity(1U);

		auto css = Gtk::CssProvider::create();
		css->load_from_resource(RESPREFIX "style.css");
		window->get_style_context()->add_provider_for_screen(Gdk::Screen::get_default(), css,
		                                                     GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

		wrapper.get_style_context()->add_class("n9-polkit-transparent-wrapper");
		wrapper.set_above_child(false);

		toplevel->set_valign(Gtk::Align::ALIGN_CENTER);
		toplevel->set_halign(Gtk::Align::ALIGN_CENTER);

		prompt->set_text(prompt_str);
		message->set_text(auth_req->message()->str());
		identity->set_text("TODO");

		deny->signal_clicked().connect([=]() { polkit_agent_session_cancel(session); });

		allow->signal_clicked().connect(sigc::mem_fun(this, &dialog::submit));

		input->signal_key_release_event().connect([&](GdkEventKey *evt) {
			if (evt->keyval == GDK_KEY_Return || evt->keyval == GDK_KEY_KP_Enter ||
			    evt->keyval == GDK_KEY_ISO_Enter) {
				submit();
				return true;
			}
			return false;
		});

		wrapper.add(*toplevel);
		wrapper.show_all();
		window->add(wrapper);
	}

	void submit() {
		auto t = input->get_text();
		polkit_agent_session_response(session, t.c_str());
	}

	std::shared_ptr<Gtk::Window> get_window() const { return window; };

	bool destroyed = false;

	~dialog() {
		if (destroyed) {
			fmt::print(stderr, "dialog: repeat destruction!\n");
		}
		destroyed = true;
		fmt::print(stderr, "dialog: destruction\n");
		window->close();
	}

	dialog(dialog &&) = delete;
};

std::optional<lsh::manager> lsh_mgr;
std::optional<lsh::multimonitor<dialog, lsh::manager &, Glib::ustring>> auth_dialog;

void on_completed(PolkitAgentSession * /*unused*/, gboolean result, void * /*unused*/) {
	fmt::print(stderr, "polkit: result: {}\n", result);
	exit(69);
}

void on_request(PolkitAgentSession * /*unused*/, gchar *request, gboolean _echo_on,
                void * /*unused*/) {
	fmt::print(stderr, "polkit: request: {}\n", request);
	auth_dialog.emplace(*lsh_mgr, request);
}

void on_show_error(PolkitAgentSession * /*unused*/, gchar *err, void * /*unused*/) {
	fmt::print(stderr, "polkit: error: {}\n", err);
}

void on_show_info(PolkitAgentSession * /*unused*/, gchar *inf, void * /*unused*/) {
	fmt::print(stderr, "polkit: info: {}\n", inf);
}

void atexit_handler() {
	fmt::print(stderr, "atexit: has auth_req_buf: {}\n", auth_req_buf != nullptr);
	if (auth_req_buf != nullptr) {
		sutil::memeset_s(auth_req_buf, auth_req_buf_len);
	}
	fmt::print(stderr, "atexit: has auth_dialog: {}\n", auth_dialog.has_value());
}

int main(int argc, char *argv[]) {
	fmt::print(stderr, "atexit: {}\n",
	           std::atexit(atexit_handler) == 0 ? "installed" : "not installed!!");

	auto app =
	    Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.pk-agent.dialog");
	lsh_mgr.emplace(app);

	int fd = std::stoi(Glib::getenv("N9_PK_FD"));
	fmt::print(stderr, "auth_req: N9_PK_FD={}\n", fd);
	{
		struct stat recv_stat {};
		fstat(fd, &recv_stat);
		auth_req_buf_len = recv_stat.st_size;
		fmt::print(stderr, "auth_req: size={}\n", auth_req_buf_len);
	}
	auth_req_buf = mmap(nullptr, auth_req_buf_len, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);

	auth_req = n9::GetAuthRequest(auth_req_buf);

	auto *id = polkit_unix_user_new(getuid());
	session = polkit_agent_session_new(id, auth_req->cookie()->c_str());
	g_object_unref(id);
	g_signal_connect(session, "completed", G_CALLBACK(on_completed), nullptr);
	g_signal_connect(session, "request", G_CALLBACK(on_request), nullptr);
	g_signal_connect(session, "show-error", G_CALLBACK(on_show_error), nullptr);
	g_signal_connect(session, "show-info", G_CALLBACK(on_show_info), nullptr);
	polkit_agent_session_initiate(session);

	app->hold();
	return app->run();
}
