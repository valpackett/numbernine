#pragma once
#include <memory>
#include "widgets/battery.hpp"
#include "widgets/clock.hpp"
#include "widgets/quicklaunch.hpp"
#include "widgets/remoteaction.hpp"
#include "widgets/separator.hpp"

static std::unique_ptr<widget> make_widget(const std::string &widget_name,
                                           std::string settings_key) {
	if (widget_name == ".battery") {
		return std::make_unique<battery>("default/" + settings_key);
	}
	if (widget_name == ".quicklaunch") {
		return std::make_unique<quicklaunch>("default/" + settings_key);
	}
	if (widget_name == ".remoteaction") {
		return std::make_unique<remoteaction>("default/" + settings_key);
	}
	if (widget_name == ".separator") {
		return std::make_unique<separator>("default/" + settings_key);
	}
	if (widget_name == ".clock") {
		return std::make_unique<klock>("default/" + settings_key);
	}
	return nullptr;
}
