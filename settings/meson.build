settings_schemas = gnome.compile_schemas(build_by_default: true,
	depend_files: files('technology.unrelenting.numbernine.settings.gschema.xml'))

install_data('technology.unrelenting.numbernine.settings.gschema.xml',
	install_dir: 'share/glib-2.0/schemas')

settings_hdrs = files(
	'xkb.hpp',
)

settings_res = gnome.compile_resources(
	'settings_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

settings_srcs = files(
	'xkb.cpp',
	'main.cpp',
)

settings_app = executable('n9-settings',
	settings_srcs, settings_hdrs, settings_schemas, settings_res,
	dependencies: [fmtlib, pugixml, wayland_client, gtk, gtkmm],
	link_with: [gutil],
	cpp_args: ['-DG_LOG_USE_STRUCTURED'],
	include_directories: [include_directories('../')],
	install: true)

run_target('run-settings', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), settings_app ])
