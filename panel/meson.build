panel_schemas = gnome.compile_schemas(build_by_default: true,
	depend_files: files('technology.unrelenting.numbernine.panel.gschema.xml'))

panel_srcs = files(
	'main.cpp',
	'panel.cpp',
	'widgets/quicklaunch.cpp',
	'widgets/remoteaction.cpp',
	'widgets/separator.cpp',
	'widgets/clock.cpp',
)

panel_hdrs = files(
	'panel.hpp',
	'widgets.hpp',
	'widgets/widget.hpp',
	'widgets/quicklaunch.hpp',
	'widgets/remoteaction.hpp',
	'widgets/separator.hpp',
	'widgets/clock.hpp',
)

panel = executable('n9-panel',
	panel_srcs, panel_schemas,
	layer_shell_client_header,
	gtk_actions_code,
	dependencies: [gtk, gtkmm],
	link_with: [lsh],
	cpp_args: ['-DG_LOG_USE_STRUCTURED'],
	include_directories: [include_directories('../')],
	install: true)

install_data('technology.unrelenting.numbernine.panel.gschema.xml',
	install_dir: 'share/glib-2.0/schemas')

run_target('run-panel', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), panel ])
