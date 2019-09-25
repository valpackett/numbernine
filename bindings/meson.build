# Cannot generate on the fly, sadly
# https://github.com/mesonbuild/meson/issues/2320
# prog_girtod = find_program('girtod')

handyd_lib = static_library('handyd',
	'handy/c/types.d',
	'handy/c/functions.d',
	# only build what we use
	'handy/TitleBar.d',
	'handy/Leaflet.d',
	'handy/Column.d',
	dependencies: [handy, gtkd],
	pic: true)

handyd = declare_dependency(
	dependencies: [handy, gtkd],
	link_with: [handyd_lib],
	include_directories: ['.'])

lshd_lib = static_library('lshd',
	'lsh/c/types.d',
	'lsh/c/functions.d',
	'lsh/LayerShell.d',
	dependencies: [gtklsh, gtkd],
	pic: true)

lshd = declare_dependency(
	dependencies: [gtklsh, gtkd],
	link_with: [lshd_lib],
	include_directories: ['.'])

polkitd_lib = static_library('polkitd',
	'polkit/c/types.d',
	'polkit/c/functions.d',
	'polkit/ActionDescription.d',
	'polkit/Authority.d',
	'polkit/AuthorizationResult.d',
	'polkit/Details.d',
	'polkit/IdentityIF.d',
	'polkit/IdentityT.d',
	# 'polkit/Permission.d',
	'polkit/SubjectIF.d',
	'polkit/SubjectT.d',
	'polkit/SystemBusName.d',
	'polkit/TemporaryAuthorization.d',
	'polkit/UnixGroup.d',
	'polkit/UnixNetgroup.d',
	'polkit/UnixProcess.d',
	'polkit/UnixSession.d',
	'polkit/UnixUser.d',
	dependencies: [polkit_agent, gtkd],
	pic: true)

polkitd = declare_dependency(
	dependencies: [polkit_agent, gtkd],
	link_with: [polkitd_lib],
	include_directories: ['.'])

polkitagentd_lib = static_library('polkitagentd',
	'polkitagent/c/types.d',
	'polkitagent/c/functions.d',
	# only build what we use
	'polkitagent/Session.d',
	dependencies: [polkit_agent, polkitd, gtkd],
	pic: true)

polkitagentd = declare_dependency(
	dependencies: [polkit_agent, polkitd, gtkd],
	link_with: [polkitagentd_lib],
	include_directories: ['.'])

upowerd_lib = static_library('upowerd',
	'upower/c/types.d',
	'upower/c/functions.d',
	# only build what we use
	'upower/Device.d',
	'upower/Client.d',
	dependencies: [upowerglib, gtkd],
	pic: true)

upowerd = declare_dependency(
	dependencies: [upowerglib, gtkd],
	link_with: [upowerd_lib],
	include_directories: ['.'])
