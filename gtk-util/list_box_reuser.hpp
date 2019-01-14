#pragma once
#include <gtkmm.h>
#include <vector>

template <typename R>
class list_box_reuser {
	Gtk::ListBox *listbox = nullptr;
	std::vector<R> holders;
	std::string resource_path;
	bool delete_from_parent = false;

 public:
	list_box_reuser(std::string res, Gtk::ListBox *lb, bool dfp)
	    : listbox(lb), resource_path(res), delete_from_parent(dfp) {
		clear();
	}

	void clear() {
		holders.clear();
		for (auto &row : listbox->get_children()) {
			listbox->remove(*row);
			delete row;
		}
	}

	void ensure_row_count(size_t len) {
		auto rows = listbox->get_children().size();
		if (len < rows) {
			for (size_t i = len; i < rows; i++) {
				listbox->get_row_at_index(i)->hide();
			}
		} else if (len > rows) {
			for (size_t i = rows; i < len; i++) {
				Glib::RefPtr<Gtk::Builder> builder = Gtk::Builder::create_from_resource(resource_path);
				R holder(builder);
				if (delete_from_parent) {
					holder.toplevel()->get_parent()->remove(*holder.toplevel());
				}
				listbox->insert(*holder.toplevel(), -1);
				holder.toplevel()->reference();
				holders.push_back(holder);
				holder.on_added();
			}
		}
		for (size_t i = 0; i < len; i++) {
			listbox->get_row_at_index(i)->show();
		}
	}

	R &operator[](size_t i) { return holders[i]; }
	const R &operator[](size_t i) const { return holders[i]; }
};
