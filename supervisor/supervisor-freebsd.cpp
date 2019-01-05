#include <poll.h>
#include <sys/procdesc.h>
#include <unistd.h>
#include <string>
#include <vector>
#include "supervisor.hpp"

/* FreeBSD has process descriptors we can poll on. We don't need no SIGCHLD! */

struct process::process_data {
	pid_t pid;
	int pd;
};

process::process(const std::string& cmd) : data(std::make_unique<process::process_data>()) {
	data->pid = pdfork(&data->pd, PD_CLOEXEC);
	if (data->pid < 0) {
		throw std::runtime_error("could not fork");
	}
	if (data->pid == 0) {
		if (execlp(cmd.c_str(), cmd.c_str()) == -1) {
			abort();
		}
	}
}

process::~process() = default;

struct supervisor::supervisor_data {
	std::vector<struct pollfd> pfds;
};

supervisor::supervisor() : data(std::make_unique<supervisor::supervisor_data>()) {}

void supervisor::add(process &proc) {
	data->pfds.push_back({.fd = proc.data->pd, .events = POLLHUP, .revents = 0});
}

void supervisor::run() {
	while (true) {
		poll(&data->pfds[0], data->pfds.size(), -1);
	}
}

supervisor::~supervisor() = default;
