#include <gtkmm.h>
#include <unistd.h>
#include "gtk-lsh/manager.hpp"
#include "gtk-lsh/multimonitor.hpp"
#include "gtk-lsh/surface.hpp"
#include "org.freedesktop.PolicyKit1.Authority_proxy.h"
#include "polkit_agent.hpp"

int main(int argc, char* argv[]) {
	auto app = Gtk::Application::create(argc, argv, "technology.unrelenting.numbernine.pk-agent");
	lsh::manager lsh_mgr(app);
	polkit_agent agent(lsh_mgr);
	agent.own_name();
	app->hold();
	Glib::signal_idle().connect([&] {
		org::freedesktop::PolicyKit1::AuthorityProxy::createForBus(
		    Gio::DBus::BUS_TYPE_SYSTEM, Gio::DBus::PROXY_FLAGS_DO_NOT_LOAD_PROPERTIES,
		    "org.freedesktop.PolicyKit1", "/org/freedesktop/PolicyKit1/Authority",
		    [=](Glib::RefPtr<Gio::AsyncResult> result) {
			    const auto proxy =
			        org::freedesktop::PolicyKit1::AuthorityProxy::createForBusFinish(result);
			    // TODO find current session
			    const Glib::Variant<Glib::ustring> var =
			        Glib::Variant<Glib::ustring>::create("/org/freedesktop/ConsoleKit/Session1");
			    proxy->RegisterAuthenticationAgent({"unix-session", {{"session-id", var}}}, "en_US.UTF-8",
			                                       "/org/freedesktop/PolicyKit1/AuthenticationAgent",
			                                       [=](auto resp) {
				                                       proxy->RegisterAuthenticationAgent_finish(resp);
				                                       std::cerr << "reg" << std::endl;
			                                       });
		    });
		return false;
	});

	return app->run();
}
