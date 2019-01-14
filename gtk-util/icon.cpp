#include "icon.hpp"
#include <iostream>

static std::unordered_map<std::string, Cairo::RefPtr<Cairo::Surface>> icon_surf_cache;

bool icon::on_draw(const Cairo::RefPtr<Cairo::Context> &cr) {
	auto scale = get_scale_factor();
	if (app_changed || last_size != size || last_scale != scale) {
		std::string cache_key =
		    app->get_id() + app->get_name() + std::to_string(size) + std::to_string(scale);
		if (icon_surf_cache.count(cache_key) != 0) {
			surf = icon_surf_cache[cache_key];
		} else {
			GtkIconInfo *icon_info_gobj = nullptr;
			auto *icon_gobj = g_app_info_get_icon(app->gobj());
			if (icon_gobj != nullptr) {
				icon_info_gobj = gtk_icon_theme_lookup_by_gicon_for_scale(
				    icon_theme->gobj(), icon_gobj, size, scale, GTK_ICON_LOOKUP_FORCE_SIZE);
			}
			if (icon_info_gobj == nullptr) {
				icon_info_gobj = gtk_icon_theme_lookup_icon_for_scale(
				    icon_theme->gobj(), "image-missing", size, scale,
				    static_cast<GtkIconLookupFlags>(GTK_ICON_LOOKUP_USE_BUILTIN |
				                                    GTK_ICON_LOOKUP_GENERIC_FALLBACK |
				                                    GTK_ICON_LOOKUP_FORCE_SIZE));
			}
			if (icon_info_gobj == nullptr) {
				std::cerr << "WTF: no fallback icon?" << std::endl;
				return true;
			}
			Gtk::IconInfo icon_info = Glib::wrap(icon_info_gobj);
			Glib::RefPtr<Gdk::Pixbuf> pbuf = icon_info.load_icon();
			surf = Cairo::RefPtr(new Cairo::Surface(
			    gdk_cairo_surface_create_from_pixbuf(pbuf->gobj(), scale, get_window()->gobj())));
			icon_surf_cache[cache_key] = surf;
		}
		set_size_request(size, size);
		last_size = size;
		last_scale = scale;
		app_changed = false;
	}
	cr->set_source(surf, 0, 0);
	cr->paint();
	return true;
}
