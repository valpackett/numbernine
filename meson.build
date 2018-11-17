project('numbernine', ['c', 'cpp'], version: '0.0.1', license: 'Unlicense',
	default_options: ['cpp_std=c++17', 'warning_level=2'])

gtk = dependency('gtk+-wayland-3.0')
gtkmm = dependency('gtkmm-3.0')
wayland_client = dependency('wayland-client')

gnome = import('gnome')

subdir('protocols')
subdir('dbus')
subdir('gtk-lsh')
subdir('panel')
subdir('notification-daemon')
