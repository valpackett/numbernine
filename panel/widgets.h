#pragma once
#include <memory>
#include "widgets/quicklaunch.h"
#include "widgets/separator.h"

static std::unique_ptr<widget> make_widget(const std::string &widget_name,
                                           std::string settings_key) {
	if (widget_name == ".quicklaunch") {
		return std::make_unique<quicklaunch>("default/" + settings_key);
	}
	if (widget_name == ".separator") {
		return std::make_unique<separator>("default/" + settings_key);
	}
	return nullptr;
}
