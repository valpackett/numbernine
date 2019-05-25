prog_flatc = find_program('flatc')
flatc = generator(prog_flatc,
	output: '@BASENAME@_generated.h',
	arguments: ['--cpp', '--scoped-enums', '-o', '@BUILD_DIR@', '@EXTRA_ARGS@', '@INPUT@'])

pk_agent_fb = flatc.process('PkAgent.fbs')
