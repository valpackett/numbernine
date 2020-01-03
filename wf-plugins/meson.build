mod2key = shared_module('mod2key', 'mod2key.cpp',
	dependencies: [wayfire, wlroots, xkbcommon],
	install: true,
	install_dir: 'lib/wayfire')
install_data('mod2key.xml', install_dir: 'share/wayfire/metadata')

magic_mirror = shared_module('magic-mirror', 'magic-mirror.cpp',
	dependencies: [wayfire, wlroots],
	install: true,
	install_dir: 'lib/wayfire')
install_data('magic-mirror.xml', install_dir: 'share/wayfire/metadata')
