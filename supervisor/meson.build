supervisor_srcs = files(
	'main.cpp',
)

supervisor = executable('n9-supervisor',
	supervisor_srcs,
	weston_desktop_shell_client_header,
	weston_desktop_shell_code,
	dependencies: [wayland_client],
	install: true)
