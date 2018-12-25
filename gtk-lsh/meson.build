lsh_srcs = files(
	'manager.cpp',
	'surface.cpp',
)

lsh_hdrs = files(
	'manager.hpp',
	'surface.hpp',
)

lsh = static_library('gtk-lsh',
	lsh_srcs,
	layer_shell_code, layer_shell_client_header, xdg_shell_code,
	dependencies: [wayland_client, gtk, gtkmm])
