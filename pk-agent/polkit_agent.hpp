#pragma once
#define POLKIT_AGENT_I_KNOW_API_IS_SUBJECT_TO_CHANGE
#include <gtkmm.h>
#include <polkitagent/polkitagent.h>
#include <map>
#include <memory>
#include <vector>
#include "auth_dialog.hpp"
#include "auth_requester.hpp"
#include "gtk-lsh/multimonitor.hpp"

#include "org.freedesktop.PolicyKit1.AuthenticationAgent_stub.h"

class polkit_agent : public org::freedesktop::PolicyKit1::AuthenticationAgent,
                     public auth_requester {
	PolkitAgentSession *session = nullptr;
	lsh::manager &lsh;

	Glib::ustring message;
	Glib::ustring user;

 public:
	std::optional<lsh::multimonitor<auth_dialog, auth_requester *, lsh::manager &, Glib::ustring>>
	    dialog;
	std::vector<std::function<void(bool)>> completed_callback;
	std::vector<std::function<void(Glib::ustring)>> show_error_callback;
	std::vector<std::function<void(Glib::ustring)>> show_info_callback;
	std::optional<AuthenticationAgentMessageHelper> auth_msg;

	polkit_agent(lsh::manager &);

	void request(Glib::ustring prompt);

	void BeginAuthentication(
	    const Glib::ustring &action_id, const Glib::ustring &message, const Glib::ustring &icon_name,
	    const std::map<Glib::ustring, Glib::ustring> &details, const Glib::ustring &cookie,
	    const std::vector<std::tuple<Glib::ustring, std::map<Glib::ustring, Glib::VariantBase>>>
	        &identities,
	    AuthenticationAgentMessageHelper msg) override;

	void CancelAuthentication(const Glib::ustring &cookie,
	                          AuthenticationAgentMessageHelper msg) override;

	void on_response(Glib::ustring &) override;
	void add_completed_callback(std::function<void(bool)>) override;
	void add_show_error_callback(std::function<void(Glib::ustring)>) override;
	void add_show_info_callback(std::function<void(Glib::ustring)>) override;
	void cancel_auth() override;
	Glib::ustring &get_message() override;
	Glib::ustring &get_user() override;
};
