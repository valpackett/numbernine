dep_scanner = dependency('wayland-scanner', native: true)
prog_scanner = find_program(dep_scanner.get_pkgconfig_variable('wayland_scanner'))
wl_code = generator(prog_scanner,
	output: '@BASENAME@-protocol.c',
	arguments: ['private-code', '@INPUT@', '@OUTPUT@'])
wl_client_header = generator(prog_scanner,
	output: '@BASENAME@-client-protocol.h',
	arguments: ['client-header', '@INPUT@', '@OUTPUT@'])

layer_shell_code = wl_code.process('wlr-layer-shell-unstable-v1.xml')
layer_shell_client_header = wl_client_header.process('wlr-layer-shell-unstable-v1.xml')

xdg_shell_code = wl_code.process('/usr/local/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml')
xdg_shell_client_header = wl_client_header.process('/usr/local/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml')
