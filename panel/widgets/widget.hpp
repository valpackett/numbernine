#pragma once
#include <gtkmm.h>

#define RESPREFIX "/technology/unrelenting/numbernine/panel/"

#define GSNAMEPREFIX "technology.unrelenting.numbernine.panel."
#define GSPATHPREFIX "/technology/unrelenting/numbernine/panel/"

class widget {
 public:
	virtual Gtk::Widget &root() = 0;
	virtual ~widget() = default;
};
