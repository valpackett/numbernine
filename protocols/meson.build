dep_protos = dependency('wayland-protocols')
system_protos_dir = dep_protos.get_pkgconfig_variable('pkgdatadir')

dep_scanner = dependency('wayland-scanner', native: true)
prog_scanner = find_program(dep_scanner.get_pkgconfig_variable('wayland_scanner'))

gen_client_header = generator(prog_scanner,
	output: ['@BASENAME@-client.h'],
	arguments: ['-c', 'client-header', '@INPUT@', '@BUILD_DIR@/@BASENAME@-client.h'])

gen_private_code = generator(prog_scanner,
	output: ['@BASENAME@.c'],
	arguments: ['-c', 'private-code', '@INPUT@', '@BUILD_DIR@/@BASENAME@.c'])


input_inhibitor_header_c = gen_client_header.process('wlr-input-inhibitor-unstable-v1.xml')
input_inhibitor_code_c = gen_private_code.process('wlr-input-inhibitor-unstable-v1.xml')

input_inhibitor_c = declare_dependency(
	sources: [input_inhibitor_header_c, input_inhibitor_code_c],
	dependencies: [wayland_client])


#capabilities_code = wl_code.process('wldip-capabilities.xml')
#capabilities_client_header = wl_client_header.process('wldip-capabilities.xml')
