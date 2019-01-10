wallpaper_schemas = gnome.compile_schemas(build_by_default: true,
	depend_files: files('technology.unrelenting.numbernine.wallpaper.gschema.xml'))

wallpaper_srcs = files(
	'main.cpp',
)

wallpaper = executable('n9-wallpaper',
	wallpaper_srcs,
	layer_shell_client_header, wallpaper_schemas,
	dependencies: [gtk, gtkmm],
	link_with: [lsh],
	cpp_args: ['-DG_LOG_USE_STRUCTURED'],
	include_directories: [include_directories('../')],
	install: true,
	install_dir: get_option('libexecdir'))

install_data('technology.unrelenting.numbernine.wallpaper.gschema.xml',
	install_dir: get_option('datadir') / 'glib-2.0/schemas')

run_target('run-wallpaper', command: [
	'env', 'GSETTINGS_SCHEMA_DIR=' + meson.current_build_dir(), wallpaper ])
