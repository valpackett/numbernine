#pragma once
#include <gtkmm.h>
#include <tuple>
#include <unordered_map>

namespace lsh {

template <typename Win, typename... Args>
class multimonitor {
	std::tuple<Args...> args;
	Glib::RefPtr<Gdk::Display> display = Gdk::Display::get_default();
	// monitor pointer used as key -- monitors shouldn't be reallocated in gdk
	std::unordered_map<GdkMonitor*, Win> windows;
	std::function<bool(Glib::RefPtr<Gdk::Monitor>&)> should_create;

 public:
	multimonitor(Args... a) : args(std::tuple<Args...>(a...)) {
		display->signal_monitor_added().connect([this](auto _) { update(); });
		update();
	}

	void set_filter(std::function<bool(Glib::RefPtr<Gdk::Monitor>&)> filter) {
		should_create = filter;
	}

	void update() {
		for (int i = 0; i < display->get_n_monitors(); i++) {
			auto monitor = display->get_monitor(i);
			if (should_create && !should_create(monitor)) {
				continue;
			}
			if (windows.count(monitor->gobj()) == 0) {
				auto elem =
				    windows.emplace(std::piecewise_construct, std::forward_as_tuple(monitor->gobj()),
				                    std::tuple_cat(args, std::make_tuple(monitor->gobj())));
				elem.first->second.layer_surface->set_on_closed([this](auto win) {
					win->hide();
					auto it = std::find_if(windows.begin(), windows.end(),
					                       [&win](const auto& p) { return p.second.get_window() == win; });
					if (it != windows.end()) {
						windows.erase(it);
					}
				});
			}
		}
	}

	multimonitor(multimonitor&&) = delete;
};

}  // namespace lsh
