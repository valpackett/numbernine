#pragma once
#include <gtkmm.h>
#include <type_traits>

namespace gutil {

template <typename T>
static inline T *get_widget(Glib::RefPtr<Gtk::Builder> &builder, Glib::ustring key) {
	T *wdg = nullptr;
	builder->get_widget(key, wdg);
	return wdg;
}

template <typename T>
static inline T *get_widget_derived(Glib::RefPtr<Gtk::Builder> &builder, Glib::ustring key) {
	T *wdg = nullptr;
	builder->get_widget_derived(key, wdg);
	return wdg;
}

template <typename T>
static inline Glib::RefPtr<T> get_object(Glib::RefPtr<Gtk::Builder> &builder, Glib::ustring key) {
	return Glib::RefPtr<T>::cast_static(builder->get_object(key));
}

}  // namespace gutil

//#define WDG(id) id(gutil::get_widget<std::remove_pointer<decltype(id)>::type>(builder, #id))

#define GLADEB(builder, typ, id) \
	typ *id { gutil::get_widget<typ>(builder, #id) }
#define GLADEB_OBJ(builder, typ, id) \
	Glib::RefPtr<typ> id { gutil::get_object<typ>(builder, #id) }
#define GLADEB_DERIVED(builder, typ, id) \
	typ *id { gutil::get_widget_derived<typ>(builder, #id) }
#define GLADEB_GOBJ(builder, typ, conv, id) \
	typ *id { conv(gtk_builder_get_object(builder->gobj(), #id)) }

#define GLADE(typ, id) GLADEB(builder, typ, id)
#define GLADE_OBJ(typ, id) GLADEB_OBJ(builder, typ, id)
#define GLADE_DERIVED(typ, id) GLADEB_DERIVED(builder, typ, id)
#define GLADE_GOBJ(typ, conv, id) GLADEB_GOBJ(builder, typ, conv, id)
