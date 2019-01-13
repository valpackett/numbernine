#pragma once

#include "Management_generated.h"

namespace inputdev {

using namespace wldip::compositor_management;

static inline bool is_pointer(const InputDevice *const dev) {
	return std::find(dev->capabilites()->begin(), dev->capabilites()->end(),
	                 DeviceCapability_Pointer) != dev->capabilites()->end();
};

static inline bool has_gestures(const InputDevice *const dev) {
	return std::find(dev->capabilites()->begin(), dev->capabilites()->end(),
	                 DeviceCapability_Gesture) != dev->capabilites()->end();
};

static inline bool is_touchpad(const InputDevice *const dev) {
	return has_gestures(dev) || dev->tap_finger_count() > 0;
};

static inline bool is_touchscreen(const InputDevice *const dev) {
	return std::find(dev->capabilites()->begin(), dev->capabilites()->end(),
	                 DeviceCapability_Touch) != dev->capabilites()->end();
};

static inline bool is_keyboard(const InputDevice *const dev) {
	return std::find(dev->capabilites()->begin(), dev->capabilites()->end(),
	                 DeviceCapability_Keyboard) != dev->capabilites()->end();
};

};  // namespace inputdev
