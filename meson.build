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
handy = dependency('libhandy-0.0', version: '>=0.0.7')
wayland_client = dependency('wayland-client')
wayland_clientpp = dependency('wayland-client++')
#flatbuffers = dependency('Flatbuffers', method: 'cmake', modules: ['flatbuffers::flatbuffers_shared'])
fmtlib = dependency('fmt')
pugixml = dependency('pugixml')
wlroots = dependency('wlroots', fallback: ['wlroots', 'wlroots'])
wayfire = dependency('wayfire')

gnome = import('gnome')
i18n = import('i18n')

conf_data = configuration_data()
conf_data.set_quoted('XKB_DIR', '/usr/local/share/X11/xkb') # TODO configurable
conf_data.set_quoted('N9_LIBEXEC_DIR', get_option('prefix') / get_option('libexecdir'))
conf_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'n9config.h', configuration: conf_data)
conf_dir = include_directories('.')

subdir('protocols')
#subdir('schemas')
subdir('dbus')

subdir('gtk-lsh')
subdir('gtk-util')
#subdir('supervisor')
subdir('wallpaper')
subdir('panel')
subdir('launcher')
subdir('notification-daemon')
subdir('settings')
subdir('wf-plugins')

# supervisor_srcs_all, supervisor_hdrs, 
all_srcs = [ lsh_srcs, gutil_srcs, wallpaper_srcs, panel_srcs, launcher_srcs, nd_srcs, settings_srcs, wfp_srcs ]
all_hdrs = [ lsh_hdrs, gutil_hdrs, wallpaper_hdrs, panel_hdrs, launcher_hdrs, settings_hdrs ]

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
