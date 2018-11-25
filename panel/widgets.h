#pragma once
#include <memory>
#include "widgets/quicklaunch.h"

static std::unique_ptr<widget> make_widget(const std::string &widget_name,
                                           std::string settings_key) {
	if (widget_name == ".quicklaunch") {
		return std::make_unique<quicklaunch>("default/" + settings_key);
	}
	return nullptr;
}
