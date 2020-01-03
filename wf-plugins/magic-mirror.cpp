#define WLR_USE_UNSTABLE
#define WAYFIRE_PLUGIN
#include <compositor-view.hpp>
#include <core.hpp>
#include <output.hpp>
#include <plugin.hpp>
#include <signal-definitions.hpp>
#include <unordered_map>

struct lol_hash {
	size_t operator()(const wayfire_view &view) const { return reinterpret_cast<size_t>(view.get()); }
};

class wayfire_magic_mirror_view_t : public wf::mirror_view_t {
	using wf::mirror_view_t::mirror_view_t;

	std::string get_title() override { return "[Mirror] " + base_view->get_title(); }

	bool should_be_decorated() override { return true; }
};

class wayfire_magic_mirror : public wf::plugin_interface_t {
	std::unordered_map<wayfire_view, wayfire_view, lol_hash> mirrors{};

	wf::signal_callback_t handle_mirror_view_unmapped = [=](wf::signal_data_t *data) {
		auto mview = get_signaled_view(data);
		mview->disconnect_signal("unmap", &handle_mirror_view_unmapped);
		for (auto it = mirrors.begin(); it != mirrors.end();) {
			if (it->second == mview) {
				it = mirrors.erase(it);
				continue;
			}
			it++;
		}
	};

	wf::activator_callback toggle_cb = [=](wf::activator_source_t, uint32_t) {
		const auto cur = output->get_top_view();
		if (mirrors.find(cur) != mirrors.end()) {
			auto m = mirrors[cur];
			m->close();
		} else {
			const auto mview = new wayfire_magic_mirror_view_t(cur);
			wf::get_core().add_view(std::unique_ptr<wf::view_interface_t>{mview});
			mirrors.emplace(cur, mview);
			mview->connect_signal("unmap", &handle_mirror_view_unmapped);
		}
		return true;
	};

	wf::option_wrapper_t<wf::activatorbinding_t> toggle_key{"magic-mirror/toggle"};

 public:
	void init() override { output->add_activator(toggle_key, &toggle_cb); }

	void fini() override {}
};

DECLARE_WAYFIRE_PLUGIN(wayfire_magic_mirror);
