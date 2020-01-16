settings_res = gnome.compile_resources(
	'settings_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

settings_app = executable('n9-settings',
	'settings.d',
	'KeyboardLayout.d',
	settings_res,
	dependencies: [gtkd, handyd, util],
	d_args: ['-relocation-model=pic'],
	install: true)

run_target('run-settings', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), settings_app ])
