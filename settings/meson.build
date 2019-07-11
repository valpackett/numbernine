settings_schemas = gnome.compile_schemas(build_by_default: true,
	depend_files: files('technology.unrelenting.numbernine.settings.gschema.xml'))

install_data('technology.unrelenting.numbernine.settings.gschema.xml',
	install_dir: 'share/glib-2.0/schemas')

settings_res = gnome.compile_resources(
	'settings_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

settings_app = executable('n9-settings',
	'settings.d', settings_schemas, wallpaper_schemas, settings_res,
	dependencies: [gtkd, handyd, util],
	d_args: ['-relocation-model=pic'],
	install: true)

run_target('run-settings', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), settings_app ])
