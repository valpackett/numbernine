dep_protos = dependency('wayland-protocols')
system_protos_dir = dep_protos.get_pkgconfig_variable('pkgdatadir')

dep_scanner = dependency('wayland-scanner', native: true)
prog_scanner = find_program(dep_scanner.get_pkgconfig_variable('wayland_scanner'))

wl_code = generator(prog_scanner,
	output: '@BASENAME@-protocol.c',
	arguments: ['private-code', '@INPUT@', '@OUTPUT@'])
wl_client_header = generator(prog_scanner,
	output: '@BASENAME@-client-protocol.h',
	arguments: ['client-header', '@INPUT@', '@OUTPUT@'])

capabilities_code = wl_code.process('wldip-capabilities.xml')
capabilities_client_header = wl_client_header.process('wldip-capabilities.xml')

layer_shell_code = wl_code.process('wlr-layer-shell-unstable-v1.xml')
layer_shell_client_header = wl_client_header.process('wlr-layer-shell-unstable-v1.xml')

xdg_shell_path = join_paths([system_protos_dir, 'stable/xdg-shell/xdg-shell.xml'])
xdg_shell_code = wl_code.process(xdg_shell_path)
xdg_shell_client_header = wl_client_header.process(xdg_shell_path)
