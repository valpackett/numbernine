project('numbernine', ['c', 'cpp', 'd'], version: '0.0.1', license: 'Unlicense',
	default_options: ['cpp_std=c++17', 'warning_level=2'])

add_global_link_arguments('-link-defaultlib-shared',
	'-L-Wl,--as-needed', language: 'd')

cxx = meson.get_compiler('cpp')

gtk = dependency('gtk+-3.0', version: '>=3.22.0')
gdk_wayland = dependency('gdk-wayland-3.0', version: '>=3.22.0')
wayland_client = dependency('wayland-client')
wayland_client_d = dependency('wayland:client', method: 'dub')
gtklsh = dependency('gtk-layer-shell-0')
handy = dependency('libhandy-0.0', version: '>=0.0.7')
polkit = dependency('polkit-gobject-1')
polkit_agent = dependency('polkit-agent-1')
upowerglib = dependency('upower-glib')
gtkd = dependency('gtkd-3', version: '>=3.8.5')
xkbcommon = dependency('xkbcommon')
wlroots = dependency('wlroots', fallback: ['wlroots', 'wlroots'])
wayfire = dependency('wayfire')
epoxy = dependency('epoxy')
qalculate = dependency('libqalculate')

gnome = import('gnome')

subdir('protocols')
subdir('bindings')
subdir('util')

subdir('wf-plugins')

subdir('shell')
subdir('pk-agent')
subdir('settings')
