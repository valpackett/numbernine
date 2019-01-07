# keep a list of them all for devtools (clang-format etc.)
supervisor_srcs_all = files(
	'main.cpp',
	'supervisor-freebsd.cpp',
)

if host_machine.system() == 'freebsd'
	supervisor_src_os = 'supervisor-freebsd.cpp'
else
	error('PORT ME: no supervisor code for ' + host_machine.system())
endif

supervisor_srcs = files(
	'main.cpp',
	supervisor_src_os,
)

supervisor_hdrs = files(
	'supervisor.hpp',
)

supervisor = executable('n9-supervisor',
	supervisor_srcs, capabilities_code, capabilities_client_header,
	dependencies: [wayland_client],
	install: true)
