#include "xkb.hpp"
#include <fmt/format.h>
#include <pugixml.hpp>
#include <iostream>
#include "n9config.h"

xkbdb::xkbdb() {
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(XKB_DIR "/rules/evdev.xml");
	if (!result) {
		throw std::runtime_error(
		    fmt::format("Could not parse XML @ {}: {}", result.offset, result.description()));
	}
	auto llist = doc.child("xkbConfigRegistry").child("layoutList");
	for (auto lay : llist.children("layout")) {
		std::map<std::string, std::string> variants;
		for (auto var : lay.child("variantList").children("variant")) {
			auto varconf = var.child("configItem");
			variants.emplace(std::string(varconf.child("name").text().as_string()),
			                 std::string(varconf.child("description").text().as_string()));
		}
		auto layconf = lay.child("configItem");
		layouts.emplace(std::string(layconf.child("name").text().as_string()),
		                xkblayout{
		                    .desc = std::string(layconf.child("description").text().as_string()),
		                    .variants = variants,
		                });
	}
}
