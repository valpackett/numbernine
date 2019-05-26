#pragma once
#include <filesystem>
#include <iostream>
#include "n9config.h"
#ifdef HAVE_EXPLICIT_BZERO
#include <strings.h>
#endif
#ifdef HAVE_MEMSET_S
#include <cstring>
#endif

namespace sutil {

static std::filesystem::path find_binary(std::filesystem::path name) {
	using namespace std::filesystem;
	path libexec(N9_LIBEXEC_DIR);
	if (getenv("N9_LIBEXEC_DIR") != nullptr) {
		path from_env(getenv("N9_LIBEXEC_DIR"));
		if (is_directory(from_env)) {
			libexec = from_env;
		}
	}
	if (is_regular_file(libexec / name)) {
		return libexec / name;
	}
	std::cerr << "could not find " << name << std::endl;
	return "";
}

static inline void memeset_s(void *buf, size_t len) {
	// why call both if both are available? why not!
#ifdef HAVE_EXPLICIT_BZERO
	explicit_bzero(buf, len);
#endif
#ifdef HAVE_MEMSET_S
	memset_s(buf, len, 0x0, len);
#endif
#if !defined(HAVE_EXPLICIT_BZERO) && !defined(HAVE_MEMSET_S)
#warning "No explicit_bzero or memset_s??"
#endif
}

}  // namespace sutil
