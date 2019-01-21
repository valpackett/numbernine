#pragma once
#include <map>
#include <string>

struct xkblayout {
	std::string desc;
	std::map<std::string, std::string> variants;
};

struct xkbgroup {
	std::string desc;
	std::map<std::string, std::string> opts;
};

struct xkbdb {
	std::map<std::string, xkblayout> layouts;
	std::map<std::string, xkbgroup> optgroups;

	xkbdb();
};
