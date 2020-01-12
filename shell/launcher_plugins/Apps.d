module launcher_plugins.Apps;
import core.memory : GC;
import std.array : join;
import std.algorithm : startsWith, any, filter, map;
import std.functional : memoize;
import std.string : chompPrefix;
import std.array : replace;
import gio.DesktopAppInfo;
import gio.AppInfoIF;
import gtk.TreeIter;
import gtk.TreeModelIF;
import gtk.TreeModelFilter;
import gtk.TreeModelSort;
import gtk.TreePath;
import gtk.TreeView;
import gtk.TreeViewColumn;
import gtk.ListStore;
import launcher_plugins.Plugin;
import Fuzzy;

// XXX: storing DesktopAppInfos themselves corrupts memory??
struct SimpleAppInfo {
	string id;
	string icon;
	string displayName;
	string genericName;
	string description;
	string[] keywords;

	this(DesktopAppInfo app) {
		this.id = app.getId();
		this.icon = app.getIcon().toString();
		this.displayName = app.getDisplayName();
		this.genericName = app.getGenericName();
		this.description = app.getDescription();
		this.keywords = app.getKeywords();
	}
}

pure bool isMatched(string needle, SimpleAppInfo app) {
	return Fuzzy.hasMatch(needle, app.displayName) || Fuzzy.hasMatch(needle, app.genericName) ||
		Fuzzy.hasMatch(needle, app.description) || app.keywords.any!(k => Fuzzy.hasMatch(needle, k));
}

pure double matchScore(string needle, SimpleAppInfo app) {
	double score = 0;
	if (Fuzzy.hasMatch(needle, app.displayName)) {
		score += Fuzzy.match(needle, app.displayName) * 10;
	}
	if (Fuzzy.hasMatch(needle, app.genericName)) {
		score += Fuzzy.match(needle, app.genericName) * 5;
	}
	if (Fuzzy.hasMatch(needle, app.description)) {
		score += Fuzzy.match(needle, app.description);
	}
	foreach (k; app.keywords) {
		if (Fuzzy.hasMatch(needle, k)) {
			score += Fuzzy.match(needle, k);
		}
	}
	return score;
}

alias memMatchScore = memoize!(matchScore, 420);

extern (C) int launcherFilterFunc(GtkTreeModel* model, GtkTreeIter* iter, void* data) {
	auto apps = cast(Apps) data;
	auto it = new TreeIter(iter);
	it.setModel(model);
	if ((it.getValueString(0) in apps.apps) is null)
		return false;
	return isMatched(apps.query, apps.apps[it.getValueString(0)]);
}

extern (C) int launcherSortFunc(GtkTreeModel* model, GtkTreeIter* a, GtkTreeIter* b, void* data) {
	auto apps = cast(Apps) data;
	auto itA = new TreeIter(a);
	auto itB = new TreeIter(b);
	itA.setModel(model);
	itB.setModel(model);
	auto appA = (apps.apps[itA.getValueString(0)]);
	auto appB = (apps.apps[itB.getValueString(0)]);
	// import std.stdio : writeln;
	// writeln("A: ", itA.getValueString(0), " - ", memMatchScore(apps.query, appA);
	// writeln("B: ", itB.getValueString(0), " - ", memMatchScore(apps.query, appB);
	auto scoreDiff = memMatchScore(apps.query, appA) - memMatchScore(apps.query, appB);
	if (scoreDiff == 0) {
		return 0;
	}
	return scoreDiff > 0 ? -1 : 1;
}

final class Apps : Plugin {
	ListStore store;
	TreeModelFilter filter;
	TreeModelSort sort;

	string query;
	SimpleAppInfo[string] apps;

	this() {
		GC.addRoot(cast(void*) this);
		GC.setAttr(cast(void*) this, GC.BlkAttr.NO_MOVE);
		store = new ListStore([GType.STRING, GType.STRING, GType.STRING]);
		filter = new TreeModelFilter(store, null);
		sort = new TreeModelSort(filter);
		filter.setVisibleFunc(&launcherFilterFunc, cast(void*) this, null);
		sort.setDefaultSortFunc(&launcherSortFunc, cast(void*) this, null);
		refreshLists();
		setAppResults(apps.values);
	}

	TreeModelIF getResultModel() {
		return sort;
	}

	pure bool matchesSearch(string) {
		return true;
	}

	void updateResults(string q) {
		query = q;
		filter.refilter();
	}

	void activateRow(TreePath path, TreeViewColumn, TreeView) {
		auto it = new TreeIter(sort, path);
		new DesktopAppInfo(it.getValueString(0)).launch(null, null);
	}

	void setAppResults(R)(R results) {
		store.clear();
		foreach (SimpleAppInfo app; results) {
			TreeIter it;
			store.append(it);
			store.setValue(it, 0, app.id);
			// XXX: couldn't get GIcon column to work
			store.setValue(it, 1, app.icon);
			store.setValue(it, 2, "<b>" ~ app.displayName ~ "</b>" ~ (app.genericName.length == 0 ?
					"" : " <span size=\"small\" weight=\"light\">(" ~ app.genericName ~ ")</span>") ~ "\n" ~
					app.description ~ " " ~ app.keywords.map!(k => "<span size=\"small\" weight=\"light\">#" ~ k ~ "</span>")
					.join(" "));
		}
	}

	void refreshLists() {
		apps.clear();
		foreach (app; DesktopAppInfo.getAll().toArray!DesktopAppInfo().filter!(x => x.shouldShow())) {
			apps[app.getId()] = SimpleAppInfo(app);
		}
	}

}
