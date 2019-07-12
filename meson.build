project('numbernine', ['c', 'cpp', 'd'], version: '0.0.1', license: 'Unlicense',
	default_options: ['cpp_std=c++17', 'warning_level=2'])

add_global_link_arguments('-link-defaultlib-shared',
	'-L-Wl,--as-needed', language: 'd')

cxx = meson.get_compiler('cpp')

if cxx.get_id() == 'clang'
	cxxfs = cxx.find_library('c++fs', required: false)
elif cxx.get_id() == 'gcc'
	cxxfs = cxx.find_library('stdc++fs', required: false)
endif

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
i18n = import('i18n')

conf_data = configuration_data()
conf_data.set_quoted('XKB_DIR', '/usr/local/share/X11/xkb') # TODO configurable
conf_data.set_quoted('N9_LIBEXEC_DIR', get_option('prefix') / get_option('libexecdir'))
conf_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
if cxx.has_function('explicit_bzero', prefix: '#include <strings.h>')
	conf_data.set('HAVE_EXPLICIT_BZERO', 1)
endif
if cxx.has_function('memset_s', prefix: '#include <cstring>')
	conf_data.set('HAVE_MEMSET_S', 1)
endif
configure_file(output: 'n9config.h', configuration: conf_data)
conf_dir = include_directories('.')

subdir('protocols')
subdir('dbus')
subdir('bindings')
subdir('util')

subdir('gtk-lsh')
subdir('gtk-util')
#subdir('supervisor')
subdir('wallpaper')
subdir('panel')
subdir('launcher')
subdir('notification-daemon')
subdir('pk-agent')
subdir('settings')
subdir('wf-plugins')
