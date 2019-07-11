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
	dependencies: [gtkd],
	pic: true)

handyd = declare_dependency(
	dependencies: [handy, gtkd],
	link_with: [handyd_lib],
	include_directories: ['.'])
