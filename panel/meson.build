panel_schemas = gnome.compile_schemas(build_by_default: true,
	depend_files: files('technology.unrelenting.numbernine.panel.gschema.xml'))

panel = executable('n9-panel',
	'main.cpp', layer_shell_client_header, panel_schemas,
	dependencies: [gtk, gtkmm],
	link_with: [lsh],
	include_directories: [include_directories('../')],
	install: true)

install_data('technology.unrelenting.numbernine.panel.gschema.xml',
	install_dir: 'share/glib-2.0/schemas')
