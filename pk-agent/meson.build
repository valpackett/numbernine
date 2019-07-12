pk_agent_dialog_res = gnome.compile_resources(
	'pk_agent_dialog_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

pk_agent_dialog = executable('n9-pk-agent-dialog',
	'dialog.d', pk_agent_dialog_res,
	dependencies: [gtkd, lshd, polkitagentd, util, input_inhibitor_dep],
	d_args: ['-relocation-model=pic'],
	install_dir: get_option('libexecdir'),
	install: true)

pk_agent = executable('n9-pk-agent',
	'agent.d',
	dependencies: [gtkd, polkitagentd, util],
	d_args: ['-relocation-model=pic', '-J../dbus'],
	install: true)

run_target('run-pk-agent', command: [
	'env',
	'N9_LIBEXEC_DIR=' + meson.current_build_dir(),
	pk_agent ])
