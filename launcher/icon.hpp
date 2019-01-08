#pragma once
#include <gtkmm.h>
#include <unordered_map>

class icon : public Gtk::DrawingArea {
	Glib::RefPtr<Gtk::IconTheme> icon_theme = Gtk::IconTheme::get_default();
	Glib::RefPtr<Gio::AppInfo> app;
	std::string cache_key;
	std::string last_cache_key;
	int last_scale = 1;
	int last_size = 48;
	int size = 48;
	Cairo::RefPtr<Cairo::Surface> surf;

 public:
	icon(BaseObjectType* cobject, const Glib::RefPtr<Gtk::Builder>& builder)
	    : Gtk::DrawingArea(cobject) {}
	void set_size(int s) { size = s; }
	void set_app(std::string ck, Glib::RefPtr<Gio::AppInfo> a) {
		cache_key = ck;
		app = a;
	}

 protected:
	bool on_draw(const Cairo::RefPtr<Cairo::Context>& cr) override;
};
