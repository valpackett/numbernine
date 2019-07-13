project('numbernine', ['c', 'cpp', 'd'], version: '0.0.1', license: 'Unlicense',
	default_options: ['cpp_std=c++17', 'warning_level=2'])

add_global_link_arguments('-link-defaultlib-shared',
	'-L-Wl,--as-needed', language: 'd')

cxx = meson.get_compiler('cpp')

gtk = dependency('gtk+-3.0', version: '>=3.22.0')
gdk_wayland = dependency('gdk-wayland-3.0', version: '>=3.22.0')
gtklsh = dependency('gtk-layer-shell-0')
handy = dependency('libhandy-0.0', version: '>=0.0.7')
polkit = dependency('polkit-gobject-1')
polkit_agent = dependency('polkit-agent-1')
gtkd = dependency('gtkd-3', version: '>=3.8.5')
gtkmm = dependency('gtkmm-3.0', version: '>=3.22.0')
cairomm = dependency('cairomm-1.0')
xkbcommon = dependency('xkbcommon')
wayland_client = dependency('wayland-client')
wayland_clientpp = dependency('wayland-client++')
fmtlib = dependency('fmt')
wlroots = dependency('wlroots', fallback: ['wlroots', 'wlroots'])
wayfire = dependency('wayfire')

gnome = import('gnome')

subdir('protocols')
subdir('dbus')
subdir('bindings')
subdir('util')

subdir('wf-plugins')

# ... will be gone ...
subdir('gtk-lsh')
subdir('gtk-util')
subdir('wallpaper')
subdir('panel')
subdir('launcher')
subdir('notification-daemon')
# ...................

subdir('shell')
subdir('pk-agent')
subdir('settings')
