notification_daemon = executable('n9-notification-daemon',
	'main.cpp', layer_shell_client_header, fdp_notifications_code,
	dependencies: [gtk, gtkmm],
	link_with: [lsh],
	include_directories: [include_directories('../')],
	install: true)
