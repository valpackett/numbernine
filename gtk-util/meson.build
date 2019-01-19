gutil_srcs = files(
	'icon.cpp',
	'button_toggler.cpp',
)

gutil_hdrs = files(
	'icon.hpp',
	'button_toggler.hpp',
	'list_box_reuser.hpp',
)

gutil = static_library('gtk-util',
	gutil_srcs,
	dependencies: [gtk, gtkmm])
