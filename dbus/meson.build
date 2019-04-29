prog_gdbusgen = find_program('../vendor/gdbus-codegen-glibmm/gdbus-codegen-glibmm.py')
gdbus_code = generator(prog_gdbusgen,
	output: ['@BASENAME@_common.cpp', '@BASENAME@_common.h', '@BASENAME@_proxy.cpp',
		'@BASENAME@_proxy.h', '@BASENAME@_stub.cpp', '@BASENAME@_stub.h'],
	arguments: ['--generate-cpp-code=@BUILD_DIR@/@BASENAME@', '@EXTRA_ARGS@', '@INPUT@'])
# NOTE: meson really wants @BUILD_DIR@ to be mentioned above, otherwise rebuilds do nothing

gtk_actions_code = gdbus_code.process('org.gtk.Actions.xml')

fdp_notifications_code = gdbus_code.process('org.freedesktop.Notifications.xml')

upower_code = gdbus_code.process('org.freedesktop.UPower.xml')
upower_device_code = gdbus_code.process('org.freedesktop.UPower.Device.xml')

polkit_authority_code = gdbus_code.process('org.freedesktop.PolicyKit1.Authority.xml')
polkit_agent_code = gdbus_code.process('org.freedesktop.PolicyKit1.AuthenticationAgent.xml')
