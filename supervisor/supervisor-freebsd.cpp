#include <fcntl.h>
#include <poll.h>
#include <sys/procdesc.h>
#include <unistd.h>
#include <iostream>
#include <string>
#include <vector>
#include "supervisor.hpp"

/* FreeBSD has process descriptors we can poll on. We don't need no SIGCHLD! */

struct process::process_data {
	pid_t pid{};
	int pd{};
	std::string cmd;
	std::function<int()> make_fd;
};

process::process(const std::string cmd, const std::function<int()> make_fd)
    : data(std::make_unique<process::process_data>()) {
	data->cmd = cmd;
	data->make_fd = make_fd;
}

void process::spawn() {
	int wlfd = data->make_fd();
	fcntl(wlfd, F_SETFD, 0);
	data->pid = pdfork(&data->pd, PD_CLOEXEC);
	if (data->pid < 0) {
		throw std::runtime_error("could not fork");
	}
	if (data->pid == 0) {
		setenv("WAYLAND_SOCKET", std::to_string(wlfd).c_str(), 1);
		if (execlp(data->cmd.c_str(), data->cmd.c_str()) == -1) {
			abort();
		}
	} else {
		close(wlfd);
	}
}

process::~process() = default;

struct supervisor::supervisor_data {
	std::vector<struct pollfd> pfds;
	std::vector<std::unique_ptr<process>> procs;
};

supervisor::supervisor() : data(std::make_unique<supervisor::supervisor_data>()) {}

void supervisor::add(const std::string cmd, const std::function<int()> prepare) {
	data->procs.push_back(std::make_unique<process>(cmd, prepare));
}

void supervisor::run() {
	for (auto& proc : data->procs) {
		proc->spawn();
		data->pfds.push_back({.fd = proc->data->pd, .events = POLLHUP, .revents = 0});
	}
	while (true) {
		poll(&data->pfds[0], data->pfds.size(), -1);
	}
}

supervisor::~supervisor() = default;
