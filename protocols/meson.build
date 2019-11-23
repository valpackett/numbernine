dep_protos = dependency('wayland-protocols')
system_protos_dir = dep_protos.get_pkgconfig_variable('pkgdatadir')

dep_scanner = dependency('wayland-scanner', native: true)
prog_scanner = find_program(dep_scanner.get_pkgconfig_variable('wayland_scanner'))

gen_client_header = generator(prog_scanner,
	output: ['@BASENAME@-client.h'],
	arguments: ['-c', 'client-header', '@INPUT@', '@BUILD_DIR@/@BASENAME@-client.h'])

gen_code = generator(prog_scanner,
	output: ['@BASENAME@.c'],
	arguments: ['-c', 'public-code', '@INPUT@', '@BUILD_DIR@/@BASENAME@.c'])


input_inhibitor_header_c = gen_client_header.process('wlr-input-inhibitor-unstable-v1.xml')
input_inhibitor_code_c = gen_code.process('wlr-input-inhibitor-unstable-v1.xml')


wl_protos_lib = static_library('wl_protos',
	input_inhibitor_header_c, input_inhibitor_code_c,
	'wl_protos_helper.c',
	'wl_protos.d',
	dependencies: [gtkd, gdk_wayland, wayland_client],
	pic: true)

wl_protos = declare_dependency(
	link_with: [wl_protos_lib],
	include_directories: ['.'])
