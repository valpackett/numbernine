#include <fcntl.h>
#include <fmt/format.h>
#include <giomm.h>
#include <signal.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <unistd.h>
#include "PkAgent_generated.h"
#include "org.freedesktop.PolicyKit1.AuthenticationAgent_stub.h"
#include "org.freedesktop.PolicyKit1.Authority_proxy.h"

using Glib::ustring;
using std::string, std::vector, std::shared_ptr, std::map, std::tuple;

struct agent_impl : public org::freedesktop::PolicyKit1::AuthenticationAgentStub {
	std::optional<MethodInvocation> auth_msg;
	Glib::Pid dialog_pid;

	void own_name() {
		Gio::DBus::own_name(
		    Gio::DBus::BUS_TYPE_SYSTEM, "org.freedesktop.PolicyKit1.AuthenticationAgent",
		    [&](const Glib::RefPtr<Gio::DBus::Connection>& connection, const ustring& name) {
			    fmt::print(stderr, "dbus: name: {}\n", name.c_str());
			    if (register_object(connection, "/org/freedesktop/PolicyKit1/AuthenticationAgent") == 0) {
				    fmt::print(stderr, "dbus: failed to register object\n");
				    exit(1);
			    }
		    },
		    Gio::DBus::SlotNameAcquired(),
		    [&](const Glib::RefPtr<Gio::DBus::Connection>& /* connection */, const ustring& name) {
			    fmt::print(stderr, "dbus: name '{}' lost (supposedly)\n", name.c_str());
			    // we get this even though everything is fine??
		    });
	}

	void on_dialog_exit(Glib::Pid pid, int code) {
		fmt::print(stderr, "child: exit {} {}\n", pid, code);
		auth_msg->ret();
	}

	void BeginAuthentication(
	    const ustring& action_id, const ustring& message, const ustring& icon_name,
	    const map<ustring, ustring>& details, const ustring& cookie,
	    const vector<tuple<ustring, map<ustring, Glib::VariantBase>>>& identities,
	    MethodInvocation& msg) override {
		using namespace n9;
		using namespace flatbuffers;
		fmt::print(stderr, "dbus: action='{}' msg='{}' icon='{}'\n ", string(action_id),
		           string(message), string(icon_name));
		auth_msg = msg;
		FlatBufferBuilder builder(8192);
		vector<uint8_t> fident_types;
		vector<Offset<void>> fidents;
		for (const auto& [typ, params] : identities) {
			if (typ != "unix-user") {
				fmt::print(stderr, "dbus: XXX: authenticating as {} instead of unix-user??", typ.c_str());
				fident_types.push_back(static_cast<uint8_t>(Ident::UnknownIdent));
				fidents.push_back(CreateUnknownIdent(builder, builder.CreateString(typ)).Union());
				continue;
			}
			fident_types.push_back(static_cast<uint8_t>(Ident::UnixUserIdent));
			fidents.push_back(
			    CreateUnixUserIdent(builder, builder.CreateString(params.at("uid").print())).Union());
		}
		builder.Finish(
		    CreateAuthRequest(builder, builder.CreateString(action_id), builder.CreateString(cookie),
		                      builder.CreateString(message), builder.CreateString(icon_name),
		                      builder.CreateVector(fident_types), builder.CreateVector(fidents)));
		int fd = shm_open(SHM_ANON, O_RDWR | O_CREAT, 0644);
		ftruncate(fd, builder.GetSize());
		write(fd, builder.GetBufferPointer(), builder.GetSize());
		lseek(fd, 0, SEEK_SET);
		vector<string> argv{
		    "/home/greg/src/github.com/myfreeweb/numbernine/build/pk-agent/n9-pk-agent-dialog"};
		Glib::setenv("N9_PK_FD", fmt::format("{}", fd));
		fcntl(fd, F_SETFD, 0);
		Glib::spawn_async("", argv, Glib::SPAWN_LEAVE_DESCRIPTORS_OPEN | Glib::SPAWN_DO_NOT_REAP_CHILD,
		                  Glib::SlotSpawnChildSetup(), &dialog_pid);
		fmt::print(stderr, "child: spawn {}\n", dialog_pid);
		Glib::signal_child_watch().connect(sigc::mem_fun(*this, &agent_impl::on_dialog_exit),
		                                   dialog_pid);
		close(fd);
	}

	void CancelAuthentication(const ustring& cookie, MethodInvocation& msg) override {
		kill(dialog_pid, SIGTERM);
	}
};

int main(int argc, char* argv[]) {
	Gio::init();

	agent_impl agent;
	agent.own_name();

	Glib::signal_idle().connect([&] {
		org::freedesktop::PolicyKit1::AuthorityProxy::createForBus(
		    Gio::DBus::BUS_TYPE_SYSTEM, Gio::DBus::PROXY_FLAGS_DO_NOT_LOAD_PROPERTIES,
		    "org.freedesktop.PolicyKit1", "/org/freedesktop/PolicyKit1/Authority",
		    [=](Glib::RefPtr<Gio::AsyncResult> result) {
			    const auto proxy =
			        org::freedesktop::PolicyKit1::AuthorityProxy::createForBusFinish(result);
			    // TODO find current session
			    const Glib::Variant<ustring> var =
			        Glib::Variant<ustring>::create("/org/freedesktop/ConsoleKit/Session1");
			    proxy->RegisterAuthenticationAgent({"unix-session", {{"session-id", var}}}, "en_US.UTF-8",
			                                       "/org/freedesktop/PolicyKit1/AuthenticationAgent",
			                                       [=](auto resp) {
				                                       proxy->RegisterAuthenticationAgent_finish(resp);
				                                       fmt::print(stderr, "dbus: registered at polkit\n");
			                                       });
		    });
		return false;
	});

	auto loop = Glib::MainLoop::create();
	loop->run();
	return 0;
}
