lsh_srcs = files(
	'manager.cpp',
	'surface.cpp',
)

lsh_hdrs = files(
	'manager.hpp',
	'surface.hpp',
	'multimonitor.hpp',
)

lsh_lib = static_library('gtk-lsh',
	lsh_srcs,
	dependencies: [layer_shell, input_inhibitor, gtk, gtkmm])

gtk_lsh = declare_dependency(
	include_directories: lsh_lib.private_dir_include(),
	link_with: lsh_lib)
