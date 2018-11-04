project('numbernine', ['c', 'cpp'], version: '0.0.1', license: 'Unlicense',
	default_options: ['cpp_std=c++17', 'warning_level=2'])

dep_scanner = dependency('wayland-scanner', native: true)
prog_scanner = find_program(dep_scanner.get_pkgconfig_variable('wayland_scanner'))
wl_code = generator(prog_scanner,
	output: '@BASENAME@-protocol.c',
	arguments: ['private-code', '@INPUT@', '@OUTPUT@'])
wl_client_header = generator(prog_scanner,
	output: '@BASENAME@-client-protocol.h',
	arguments: ['client-header', '@INPUT@', '@OUTPUT@'])

layer_shell_code = wl_code.process('protocols/wlr-layer-shell-unstable-v1.xml')
layer_shell_client_header = wl_client_header.process('protocols/wlr-layer-shell-unstable-v1.xml')

xdg_shell_code = wl_code.process('/usr/local/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml')
xdg_shell_client_header = wl_client_header.process('/usr/local/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml')

gtk = dependency('gtk+-wayland-3.0')
gtkmm = dependency('gtkmm-3.0')
wayland_client = dependency('wayland-client')

gnome = import('gnome')

subdir('gtk-lsh')
subdir('panel')
