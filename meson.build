project('numbernine', ['c', 'cpp'], version: '0.0.1', license: 'Unlicense',
	default_options: ['cpp_std=c++17', 'warning_level=2'])

cxx = meson.get_compiler('cpp')

if cxx.get_id() == 'clang'
	cxxfs = cxx.find_library('c++fs', required: false)
elif cxx.get_id() == 'gcc'
	cxxfs = cxx.find_library('stdc++fs', required: false)
endif

gtk = dependency('gtk+-wayland-3.0', version: '>=3.22.0')
gtkmm = dependency('gtkmm-3.0', version: '>=3.22.0')
cairomm = dependency('cairomm-1.0')
wayland_client = dependency('wayland-client')

gnome = import('gnome')

conf_data = configuration_data()
conf_data.set_quoted('N9_LIBEXEC_DIR', get_option('prefix') / get_option('libexecdir'))
configure_file(output: 'n9config.h', configuration: conf_data)
conf_dir = include_directories('.')

subdir('protocols')
subdir('dbus')
subdir('supervisor')
subdir('gtk-lsh')
subdir('wallpaper')
subdir('panel')
subdir('launcher')
subdir('notification-daemon')

all_srcs = [ lsh_srcs, supervisor_srcs_all, wallpaper_srcs, panel_srcs, launcher_srcs, nd_srcs ]
all_hdrs = [ lsh_hdrs, supervisor_hdrs, wallpaper_hdrs, panel_hdrs, launcher_hdrs ]

prog_clang_format = find_program('clang-format80', 'clang-format70', 'clang-format60', 'clang-format', required: false)
if prog_clang_format.found()
	run_target('fmt', command: [ prog_clang_format, '-i', all_srcs, all_hdrs ])
endif

prog_clang_tidy = find_program('clang-tidy80', 'clang-tidy70', 'clang-tidy60', 'clang-tidy', required: false)
if prog_clang_tidy.found()
	run_target('tidy', command: [ prog_clang_tidy, all_srcs ])
	run_target('fix',  command: [ prog_clang_tidy, '-fix-errors', '-fix', all_srcs ])
endif

prog_cppcheck = find_program('cppcheck', required: false)
if prog_cppcheck.found()
	run_target('check', command: [ prog_cppcheck, all_srcs, all_hdrs ])
endif
