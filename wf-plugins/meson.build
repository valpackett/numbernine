wfp_srcs = files(
	'gsettings.cpp',
)

gsettings = shared_module('gsettings', 'gsettings.cpp',
	dependencies: [wayfire, wlroots, gtkmm],
	install: true,
	install_dir: 'lib/wayfire')
