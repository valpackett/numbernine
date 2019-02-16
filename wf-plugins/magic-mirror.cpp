#define WLR_USE_UNSTABLE
#define WAYFIRE_PLUGIN
#include <compositor-view.hpp>
#include <config.hpp>
#include <core.hpp>
#include <output.hpp>
#include <signal-definitions.hpp>
#include <unordered_map>

struct lol_hash {
	size_t operator()(const wayfire_view &view) const { return reinterpret_cast<size_t>(view.get()); }
};

class wayfire_magic_mirror_view_t : public wayfire_mirror_view_t {
	using wayfire_mirror_view_t::wayfire_mirror_view_t;

	std::string get_title() override { return "[Mirror] " + original_view->get_title(); }

	bool should_be_decorated() override { return true; }
};

class wayfire_magic_mirror : public wayfire_plugin_t {
	std::unordered_map<wayfire_view, wayfire_view, lol_hash> mirrors;

	signal_callback_t handle_mirror_view_unmapped = [=](signal_data *data) {
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

	activator_callback toggle_cb = [=](wf_activator_source, uint32_t) {
		const auto cur = output->get_top_view();
		if (mirrors.find(cur) != mirrors.end()) {
			auto m = mirrors[cur];
			m->unmap();
			m->destroy();
		} else {
			const auto mview = new wayfire_magic_mirror_view_t(cur);
			core->add_view(std::unique_ptr<wayfire_view_t>{mview});
			mirrors.emplace(cur, mview);
			mview->map();
			mview->connect_signal("unmap", &handle_mirror_view_unmapped);
		}
	};

 public:
	void init(wayfire_config *config) {
		auto section = config->get_section("magic-mirror");
		auto toggle_key = section->get_option("toggle", "<super> <shift> KEY_M");
		output->add_activator(toggle_key, &toggle_cb);
	}

	void fini() {}
};

extern "C" {
wayfire_plugin_t *newInstance() { return new wayfire_magic_mirror(); }
}
