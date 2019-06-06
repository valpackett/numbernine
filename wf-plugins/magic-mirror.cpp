#define WLR_USE_UNSTABLE
#define WAYFIRE_PLUGIN
#include <plugin.hpp>
#include <compositor-view.hpp>
#include <config.hpp>
#include <core.hpp>
#include <output.hpp>
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

class wayfire_magic_mirror : public wayfire_plugin_t {
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

	activator_callback toggle_cb = [=](wf_activator_source, uint32_t) {
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
	};

 public:
	void init(wayfire_config *config) override {
		auto section = config->get_section("magic-mirror");
		auto toggle_key = section->get_option("toggle", "<super> <shift> KEY_M");
		output->add_activator(toggle_key, &toggle_cb);
	}

	void fini() override {}
};

extern "C" {
wayfire_plugin_t *newInstance() { return new wayfire_magic_mirror(); }
}
