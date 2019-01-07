launcher_res = gnome.compile_resources(
	'launcher_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

launcher_srcs = files(
	'main.cpp',
)

launcher_hdrs = files(
	'app_list.hpp',
)

launcher = executable('n9-launcher',
	launcher_srcs, launcher_res,
	layer_shell_client_header,
	dependencies: [gtk, gtkmm],
	link_with: [lsh],
	cpp_args: ['-DG_LOG_USE_STRUCTURED'],
	include_directories: [include_directories('../')],
	install: true)

run_target('run-launcher', command: [
	'env', launcher ])
