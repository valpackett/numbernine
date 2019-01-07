#pragma once
#include <functional>
#include <memory>

/* this is almost the pImpl pattern, but only for data, not implementations */

class supervisor;

class process {
	struct process_data;
	std::unique_ptr<process_data> data;

 public:
	process(const std::string cmd, const std::function<int()> make_fd);
	void spawn();
	friend class supervisor;
	~process();
};

class supervisor {
	struct supervisor_data;
	std::unique_ptr<supervisor_data> data;

 public:
	supervisor();
	void add(const std::string cmd, const std::function<int()> make_fd);
	void run();
	~supervisor();
};
