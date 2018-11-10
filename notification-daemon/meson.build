nd_res = gnome.compile_resources(
	'nd_res', 'r.gresource.xml',
	source_dir: '.',
	c_name: 'as')

notification_daemon = executable('n9-notification-daemon',
	'main.cpp', nd_res, layer_shell_client_header, fdp_notifications_code,
	dependencies: [gtk, gtkmm],
	link_with: [lsh],
	include_directories: [include_directories('../')],
	install: true)
