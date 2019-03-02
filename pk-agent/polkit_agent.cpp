#include <iostream>

#include <fmt/format.h>
#include "gtk-lsh/manager.hpp"
#include "polkit_agent.hpp"

#include "org.freedesktop.PolicyKit1.Authority_proxy.h"

using Glib::ustring;
using std::string, std::vector, std::shared_ptr, std::map, std::tuple;

polkit_agent::polkit_agent(lsh::manager& l)
    : org::freedesktop::PolicyKit1::AuthenticationAgent(), lsh(l){};

void polkit_agent::request(ustring prompt) {
	completed_callback.clear();
	show_error_callback.clear();
	show_info_callback.clear();
	dialog.emplace(this, lsh, prompt);
}

static void on_completed(PolkitAgentSession* session, gboolean result, polkit_agent* agent) {
	std::cerr << "result " << result << std::endl;
	g_object_unref(session);
	for (auto& f : agent->completed_callback) {
		f(result);
	}
	agent->completed_callback.clear();
	agent->show_error_callback.clear();
	agent->show_info_callback.clear();
	agent->dialog.reset();
	// data->clear_session(session);
	// if (result) {
	agent->auth_msg->ret();
	//}
}

static void on_request(PolkitAgentSession* session, gchar* request, gboolean echo_on,
                       polkit_agent* agent) {
	std::cerr << "on_request " << request << std::endl;
	agent->request(request);
}

static void on_show_error(PolkitAgentSession* session, gchar* err, polkit_agent* agent) {
	std::cerr << "err " << err << std::endl;
	for (auto& f : agent->show_error_callback) {
		f(Glib::convert_return_gchar_ptr_to_ustring(err));
	}
}

static void on_show_info(PolkitAgentSession* session, gchar* err, polkit_agent* agent) {
	std::cerr << "inf " << err << std::endl;
	for (auto& f : agent->show_info_callback) {
		f(Glib::convert_return_gchar_ptr_to_ustring(err));
	}
}

void polkit_agent::BeginAuthentication(
    const ustring& action_id, const ustring& message_, const ustring& icon_name,
    const map<ustring, ustring>& details, const ustring& cookie,
    const vector<tuple<ustring, map<ustring, Glib::VariantBase>>>& identities,
    AuthenticationAgentMessageHelper msg) {
	// TODO handle if (session != nullptr)
	// TODO use identities
	message = message_;
	auto* id = polkit_unix_user_new(getuid());
	session = polkit_agent_session_new(id, cookie.c_str());
	for (const auto& [k, v] : identities) {
		if (k != "unix-user") {
			fmt::print(stderr, "XXX: authenticating as {} instead of unix-user??", k.c_str());
		}
		for (const auto& [kk, vv] : v) {
			if (kk == "uid") {
				user = vv.print();
			}
		}
	}
	fmt::print(stderr, " action {}\n msg {}\n icon {}\n ", string(action_id), string(message),
	           string(icon_name));
	g_object_unref(id);
	g_signal_connect(session, "completed", G_CALLBACK(on_completed), this);
	g_signal_connect(session, "request", G_CALLBACK(on_request), this);
	g_signal_connect(session, "show-error", G_CALLBACK(on_show_error), this);
	g_signal_connect(session, "show-info", G_CALLBACK(on_show_info), this);
	polkit_agent_session_initiate(session);
	auth_msg = msg;
}

void polkit_agent::CancelAuthentication(const ustring& cookie,
                                        AuthenticationAgentMessageHelper msg) {
	cancel_auth();
	msg.ret();
}

void clear_session(PolkitAgentSession* session) {
	// TODO
}

void polkit_agent::on_response(Glib::ustring& answer) {
	polkit_agent_session_response(session, answer.c_str());
}

void polkit_agent::add_completed_callback(std::function<void(bool)> f) {
	completed_callback.push_back(f);
};

void polkit_agent::add_show_error_callback(std::function<void(Glib::ustring)> f) {
	show_error_callback.push_back(f);
};

void polkit_agent::add_show_info_callback(std::function<void(Glib::ustring)> f) {
	show_info_callback.push_back(f);
};

void polkit_agent::cancel_auth() { polkit_agent_session_cancel(session); }

ustring& polkit_agent::get_message() { return message; }

ustring& polkit_agent::get_user() { return user; }
