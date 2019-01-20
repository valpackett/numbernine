prog_flatc = find_program('flatc')
flatc = generator(prog_flatc,
	output: '@BASENAME@_generated.h',
	arguments: ['--cpp', '-o', '@BUILD_DIR@', '@EXTRA_ARGS@', '@INPUT@'])
