gutil_srcs = files(
	'icon.cpp',
)

gutil_hdrs = files(
	'glade.hpp',
	'icon.hpp',
	'list_box_reuser.hpp',
)

gutil_lib = static_library('gtk-util',
	gutil_srcs,
	dependencies: [gtk, gtkmm, cairomm])

gtk_util = declare_dependency(
	link_with: gutil_lib)
