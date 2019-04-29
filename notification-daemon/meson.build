nd_res = gnome.compile_resources(
	'nd_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

nd_srcs = files(
	'main.cpp',
)

notification_daemon = executable('n9-notification-daemon',
	nd_srcs, nd_res, fdp_notifications_code,
	dependencies: [gtk_lsh, gtk_util, gtk, gtkmm, fmtlib],
	include_directories: [include_directories('../')],
	install: true,
	install_dir: get_option('libexecdir'))

run_target('run-nd', command: [ notification_daemon ])
