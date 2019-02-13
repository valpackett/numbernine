wfp_srcs = files(
	'gsettings.cpp',
	'mod2key.cpp',
)

gsettings = shared_module('gsettings', 'gsettings.cpp',
	dependencies: [wayfire, wlroots, gtkmm],
	install: true,
	install_dir: 'lib/wayfire')

mod2key = shared_module('mod2key', 'mod2key.cpp',
	dependencies: [wayfire, wlroots, xkbcommon],
	install: true,
	install_dir: 'lib/wayfire')
