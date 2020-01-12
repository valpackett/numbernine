shell_schemas = gnome.compile_schemas(build_by_default: true,
	depend_files: files('technology.unrelenting.numbernine.Shell.gschema.xml'))

install_data('technology.unrelenting.numbernine.Shell.gschema.xml',
	install_dir: get_option('datadir') / 'glib-2.0/schemas')

shell_res = gnome.compile_resources(
	'shell_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

shell = executable('n9-shell',
	'Global.d',
	'Fuzzy.d',
	'NotificationServer.d',
	'PanelManager.d',
	'PanelPopover.d',
	'Panel.d',
	'applets/Applet.d',
	'applets/Clock.d',
	'applets/Launcher.d',
	'applets/Notifier.d',
	'applets/Spacer.d',
	'applets/Power.d',
	'launcher_plugins/Plugin.d',
	'launcher_plugins/Calculator.d',
	'launcher_plugins/Calculator_helper.cpp',
	'shell.d',
	shell_schemas,
	shell_res,
	dependencies: [gtkd, lshd, upowerd, util, qalculate],
	d_args: ['-relocation-model=pic', '-J../dbus'],
	install: true)

run_target('run-shell', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), shell ])
