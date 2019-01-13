settings_schemas = gnome.compile_schemas(build_by_default: true,
	depend_files: files('technology.unrelenting.numbernine.settings.gschema.xml'))

settings_app_res = gnome.compile_resources(
	'settings_app_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

settings_app_srcs = files(
	'app.cpp',
)

settings_app = executable('n9-settings',
	settings_app_srcs, settings_schemas, settings_app_res,
	compositor_management_fb, compositor_management_code, compositor_management_client_header,
	dependencies: [fmtlib, wayland_client, gtk, gtkmm, flatbuffers],
	cpp_args: ['-DG_LOG_USE_STRUCTURED'],
	include_directories: [include_directories('../')],
	install: true)

install_data('technology.unrelenting.numbernine.settings.gschema.xml',
	install_dir: 'share/glib-2.0/schemas')

run_target('run-settings', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), settings_app ])
