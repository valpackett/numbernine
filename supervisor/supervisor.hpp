#pragma once
#include <memory>

/* this is almost the pImpl pattern, but only for data, not implementations */

class supervisor;

class process {
	struct process_data;
	std::unique_ptr<process_data> data;

 public:
	process(const std::string& cmd);
	friend class supervisor;
	~process();
};

class supervisor {
	struct supervisor_data;
	std::unique_ptr<supervisor_data> data;

 public:
	supervisor();
	void add(process &proc);
	void run();
	~supervisor();
};
