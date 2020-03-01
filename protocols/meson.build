wl_gtk_d_code = static_library('wl_gtk_d',
	'WaylandGtkD.d',
	dependencies: [gtkd, gdk_wayland, wayland_client, wayland_client_d],
	d_module_versions: ['WlStatic'],
	pic: true)

wl_gtk_d = declare_dependency(
	link_with: [wl_gtk_d_code],
	dependencies: [gtkd, gdk_wayland, wayland_client, wayland_client_d],
	include_directories: ['.'])

prog_dub = find_program('dub')
gen_wayland_d = generator(prog_dub,
	output: ['@BASENAME@.d'],
	arguments: ['run', 'wayland:scanner', '--',
		'-i', '@INPUT@', '-o', '@OUTPUT@', '-m', '@BASENAME@'])

input_inhibitor_code_d = gen_wayland_d.process('wlr_input_inhibitor_unstable_v1.xml')
foreign_toplevel_code_d = gen_wayland_d.process('wlr_foreign_toplevel_management_unstable_v1.xml')
