util_lib = static_library('util',
	# only build what actually gets compiled
	# (seemingly template-only modules can be compiled..)
	'DBus.d',
	'Vals.d',
	dependencies: [polkit_agent, polkitd, gtkd],
	pic: true)

util = declare_dependency(
	link_with: [util_lib],
	include_directories: ['.'])
