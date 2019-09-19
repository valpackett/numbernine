shell_schemas = gnome.compile_schemas(build_by_default: true,
	depend_files: files('technology.unrelenting.numbernine.Shell.gschema.xml'))

shell_res = gnome.compile_resources(
	'shell_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

shell = executable('n9-shell',
	'Global.d',
	'NotificationServer.d',
	'PanelManager.d',
	'Panel.d',
	'applets/Applet.d',
	'applets/Clock.d',
	'applets/Notifier.d',
	'applets/Spacer.d',
	'shell.d',
	shell_schemas,
	shell_res,
	dependencies: [gtkd, lshd, util],
	d_args: ['-relocation-model=pic', '-J../dbus'],
	install: true)

run_target('run-shell', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), shell ])
