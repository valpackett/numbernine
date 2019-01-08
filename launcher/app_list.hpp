#include <gtkmm.h>
#include <iostream>
#include <unordered_map>
#define FTS_FUZZY_MATCH_IMPLEMENTATION
#include "vendor/fts_fuzzy_match.hpp"

const size_t MAX_MATCHES = 24;

class app_list {
 public:
	std::vector<Glib::RefPtr<Gio::DesktopAppInfo>> apps;
	std::unordered_map<std::string, std::vector<size_t>> cats;

	void refresh() {
		auto all = Gio::DesktopAppInfo::get_all();
		size_t i = 0;
		for (auto it = all.begin(); it != all.end(); it++) {
			auto app = Glib::RefPtr<Gio::DesktopAppInfo>::cast_static(*it);
			if (!app->should_show()) {
				continue;
			}
			apps.push_back(app);
			auto cat_list = app->get_categories();
			auto start = cat_list.begin();
			auto end = cat_list.end();
			auto next = std::find(start, end, ';');
			while (next != end) {
				cats[std::string(start, next)].push_back(i);
				start = next + 1;
				next = std::find(start, end, ';');
			}
			i++;
		}
	}

	std::vector<size_t> fuzzy_search(Glib::ustring query) {
		std::vector<size_t> indices;
		std::vector<int> scores;
		size_t i = 0, matches = 0;
		for (auto &app : apps) {
			int score = 0;
			if (!fts::fuzzy_match(query.c_str(), app->get_name().c_str(), score)) {
				i++;
				continue;
			}
			auto lb = std::lower_bound(scores.begin(), scores.end(), score, std::greater<int>());
			auto dist = std::distance(scores.begin(), lb);
			scores.insert(lb, score);
			indices.insert(indices.begin() + dist, i++);
			if (matches++ > MAX_MATCHES) {
				break;
			}
		}
		return indices;
	}
};
