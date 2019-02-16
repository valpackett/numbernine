dep_protos = dependency('wayland-protocols')
system_protos_dir = dep_protos.get_pkgconfig_variable('pkgdatadir')

dep_scannerpp = dependency('wayland-scanner++', native: true)
prog_scannerpp = find_program(dep_scannerpp.get_pkgconfig_variable('wayland_scannerpp'))

scannerpp = generator(prog_scannerpp,
	output: ['@BASENAME@-protocol.hpp', '@BASENAME@-protocol.cpp'],
	arguments: ['@EXTRA_ARGS@', '@INPUT@', '@BUILD_DIR@/@BASENAME@-protocol.hpp', '@BUILD_DIR@/@BASENAME@-protocol.cpp'])

#capabilities_code = wl_code.process('wldip-capabilities.xml')
#capabilities_client_header = wl_client_header.process('wldip-capabilities.xml')

xdg_shell_path = system_protos_dir / 'stable/xdg-shell/xdg-shell.xml'
xdg_shell_code = scannerpp.process(xdg_shell_path)

xdg_shell = declare_dependency(
	sources: [xdg_shell_code],
	dependencies: [wayland_clientpp])

layer_shell_code = scannerpp.process('wlr-layer-shell-unstable-v1.xml',
	extra_args: ['-x', 'xdg-shell-protocol.hpp'])

layer_shell = declare_dependency(
	sources: [layer_shell_code],
	dependencies: [xdg_shell, wayland_clientpp])
