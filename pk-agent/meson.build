pk_agent_res = gnome.compile_resources(
	'pk_agent_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

pk_agent_srcs = files(
	'main.cpp',
	'auth_dialog.cpp',
	'polkit_agent.cpp',
)

pk_agent_hdrs = files(
	'auth_dialog.hpp',
	'polkit_agent.hpp',
)

pk_agent = executable('n9-pk-agent',
	pk_agent_srcs,
	pk_agent_res,
	polkit_authority_code,
	polkit_agent_code,
	dependencies: [gtk_lsh, gtk_util, gtk, gtkmm, polkit_agent, fmtlib],
	cpp_args: ['-DG_LOG_USE_STRUCTURED'],
	include_directories: [include_directories('../')],
	install: true,
	install_dir: get_option('libexecdir'))

run_target('run-pk-agent', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), pk_agent ])
