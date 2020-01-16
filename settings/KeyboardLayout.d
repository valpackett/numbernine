module KeyboardLayout;
import gio.Settings;
import gtk.Dialog;
import gtk.TreeStore;
import gtk.TreeView;
import gtk.TreeIter;
import Glade;
import Vals;
import std.xml;
import std.file;
import std.format;
import std.typecons : Tuple;
import std.array : split, join;

struct XkbLayout {
	string desc;
	string[string] variants;
}

struct XkbGroup {
	string desc;
	string[string] opts;
}

alias XkbStuff = Tuple!(string[], "layouts", string[], "variants");

XkbStuff getXkb(Settings settings) {
	XkbStuff result;
	result.layouts = settings.getValue("xkb-layout").toDVal!(string).split(",");
	result.variants = settings.getValue("xkb-variant").toDVal!(string).split(",");
	return result;
}

void setXkb(Settings settings, XkbStuff stuff) {
	settings.setValue("xkb-layout", stuff.layouts.join(",").toVariant!());
	settings.setValue("xkb-variant", stuff.variants.join(",").toVariant!());
}

void loadLayouts(ref XkbLayout[string] layouts) {
	string s = cast(string) std.file.read("/usr/local/share/X11/xkb/rules/evdev.xml"); // TODO dir from meson
	auto xml = new DocumentParser(s);
	xml.onStartTag["layout"] = (ElementParser xml) {
		string key;
		XkbLayout layout;
		xml.onStartTag["configItem"] = (ElementParser xml) {
			xml.onEndTag["name"] = (in Element e) { key = e.text(); };
			xml.onEndTag["description"] = (in Element e) { layout.desc = e.text(); };
			xml.parse();
		};
		xml.onStartTag["variant"] = (ElementParser xml) {
			string key;
			string desc;
			xml.onEndTag["name"] = (in Element e) { key = e.text(); };
			xml.onEndTag["description"] = (in Element e) { desc = e.text(); };
			xml.parse();
			layout.variants[key] = desc;
		};
		xml.parse();
		layouts[key] = layout;
	};
	xml.parse();
}

final class AddLayoutDialog {
	@ById("dialog_add_keyboard_layout") Dialog dialog;
	@ById("tree_add_keyboard_layout") TreeView tree;
	@ById("tree_store_xkb_layouts") TreeStore layoutStore;

	mixin Glade!("/technology/unrelenting/numbernine/settings/dialogs.glade");
	mixin Css!("/technology/unrelenting/numbernine/settings/style.css", dialog);
	mixin AutoThis!();

	void setLayouts(ref XkbLayout[string] layouts) {
		// layoutStore.clear();
		foreach (lkey, layout; layouts) {
			TreeIter layI = layoutStore.append(null);
			layoutStore.setValue(layI, 0, lkey);
			layoutStore.setValue(layI, 1, layout.desc);
			layoutStore.setValue(layI, 2, lkey);
			foreach (vkey, vdesc; layout.variants) {
				TreeIter varI = layoutStore.append(layI);
				layoutStore.setValue(varI, 0, format("%s(%s)", lkey, vkey));
				layoutStore.setValue(varI, 1, vdesc);
				layoutStore.setValue(varI, 2, lkey);
				layoutStore.setValue(varI, 3, vkey);
			}
		}
	}

	void addToSettings(Settings settings) {
		auto iter = tree.getSelectedIter();
		if (iter is null) {
			return;
		}
		auto xkb = getXkb(settings);
		xkb.layouts ~= iter.getValueString(2);
		xkb.variants ~= iter.getValueString(3);
		setXkb(settings, xkb);
	}
}
