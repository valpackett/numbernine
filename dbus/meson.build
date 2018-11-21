prog_gdbusgen = find_program('../vendor/gdbus-codegen-glibmm/gdbus-codegen-glibmm.py')
gdbus_code = generator(prog_gdbusgen,
	output: ['@BASENAME@', '@BASENAME@_common.cpp', '@BASENAME@_common.h', '@BASENAME@_proxy.cpp',
		'@BASENAME@_proxy.h', '@BASENAME@_stub.cpp', '@BASENAME@_stub.h'],
	arguments: ['--generate-cpp-code=@OUTPUT0@', '@INPUT@'])

fdp_notifications_code = gdbus_code.process('org.freedesktop.Notifications.xml')
