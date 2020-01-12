module launcher_plugins.Calculator;
import core.stdcpp.string;
import std.algorithm : startsWith;
import std.string : chompPrefix;
import std.array : replace;
import glib.SimpleXML;
import gtk.TreeIter;
import gtk.TreeModelIF;
import gtk.TreePath;
import gtk.TreeView;
import gtk.TreeViewColumn;
import gtk.ListStore;
import gtk.Clipboard;
import gdk.Display;
import launcher_plugins.Plugin;

extern (C++) basic_string!(char) n9_qalculate_do(basic_string!(char));
extern (C++) void n9_qalculate_load();

final class Calculator : Plugin {
	ListStore store;
	TreeIter it;

	this() {
		store = new ListStore([GType.STRING, GType.STRING, GType.STRING]);
		store.append(it);
		n9_qalculate_load();
	}

	TreeModelIF getResultModel() {
		return store;
	}

	pure bool matchesSearch(string q) {
		return startsWith(q, "=");
	}

	void updateResults(string q) {
		string qq = chompPrefix(q, "=");
		string res = cast(string) n9_qalculate_do(basic_string!(char)(qq)).toString;
		store.setValue(it, 0, "");
		store.setValue(it, 1, "accessories-calculator");
		store.setValue(it, 2, SimpleXML.markupEscapeText(res, res.length));
	}

	void activateRow(TreePath path, TreeViewColumn, TreeView) {
		auto it = new TreeIter(store, path);
		auto s = it.getValueString(2);
		Clipboard.getDefault(Display.getDefault()).setText(s, cast(int) s.length);
	}
}
