#pragma once
#include <functional>
#include <gtkmm.h>

class auth_requester {
	public:
	virtual void on_response(Glib::ustring&) = 0;
	virtual void add_completed_callback(std::function<void(bool)>) = 0;
	virtual void add_show_error_callback(std::function<void(Glib::ustring)>) = 0;
	virtual void add_show_info_callback(std::function<void(Glib::ustring)>) = 0;
	virtual void cancel_auth() = 0;
	virtual Glib::ustring& get_message() = 0;
	virtual Glib::ustring& get_user() = 0;

};
