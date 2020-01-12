module applets.Launcher;
import std.array : split, join;
import std.algorithm.iteration : filter, map;
import std.algorithm.searching : canFind, any;
import std.functional : memoize;
import core.memory : GC;
import gtk.Widget;
import gtk.Label;
import gtk.Button;
import gtk.ToggleButton;
import gtk.Image;
import gtk.Box;
import gtk.Grid;
import gtk.ScrolledWindow;
import gtk.ListStore;
import gtk.TreeModelFilter;
import gtk.TreeModelSort;
import gtk.TreeModelIF;
import gtk.TreeSortableIF;
import gtk.TreeView;
import gtk.TreeViewColumn;
import gtk.TreeIter;
import gtk.TreePath;
import gtk.SearchEntry;
import gdk.Keysyms;
import gio.Settings;
import gio.DesktopAppInfo;
import gio.AppInfoIF;
import gobject.Value;
import gobject.ObjectG;
import applets.Applet;
import Fuzzy;
import PanelPopover;
import Panel;
import Global;
import Glade;

struct SimpleAppInfo {
	string displayName;
	string genericName;
	string description;
	string[] keywords;

	this(DesktopAppInfo app) {
		this.displayName = app.getDisplayName();
		this.genericName = app.getGenericName();
		this.description = app.getDescription();
		// XXX: reading keywords seems to introduce memory corruption
		// this.keywords = app.getKeywords();
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
	auto launcher = cast(Launcher) data;
	auto it = new TreeIter(iter);
	it.setModel(model);
	auto needle = launcher.searchbar.getText();
	return isMatched(needle, SimpleAppInfo(launcher.apps[it.getValueString(0)]));
}

extern (C) int launcherSortFunc(GtkTreeModel* model, GtkTreeIter* a, GtkTreeIter* b, void* data) {
	auto launcher = cast(Launcher) data;
	auto itA = new TreeIter(a);
	auto itB = new TreeIter(b);
	itA.setModel(model);
	itB.setModel(model);
	auto needle = launcher.searchbar.getText();
	auto appA = SimpleAppInfo(launcher.apps[itA.getValueString(0)]);
	auto appB = SimpleAppInfo(launcher.apps[itB.getValueString(0)]);
	// import std.stdio : writeln;
	// writeln("A: ", itA.getValueString(0), " - ", memMatchScore(needle, appA);
	// writeln("B: ", itB.getValueString(0), " - ", memMatchScore(needle, appB);
	auto scoreDiff = memMatchScore(needle, appA) - memMatchScore(needle, appB);
	if (scoreDiff == 0) {
		return 0;
	}
	return scoreDiff > 0 ? -1 : 1;
}

final class Launcher : Applet {
	ToggleButton root;
	Settings settings;
	PanelPopover popover;

	@ById("toplevel") Grid toplevel;
	@ById("resultstore") ListStore resultstore;
	@ById("resultfilter") TreeModelFilter resultfilter;
	@ById("resultsort") TreeModelSort resultsort;
	@ById("resultview") TreeView resultview;
	@ById("searchbar") SearchEntry searchbar;

	mixin Glade!("/technology/unrelenting/numbernine/Shell/applets/Launcher.glade");
	mixin Css!("/technology/unrelenting/numbernine/Shell/style.css", toplevel);

	DesktopAppInfo[string] apps;
	string[][string] cats;

	invariant {
		foreach (_, as; cats)
			foreach (a; as)
				assert((a in apps) != null);
	}

	Widget rootWidget() {
		return root;
	}

	this(string name, Panel panel) {
		GC.addRoot(cast(void*) this);
		GC.setAttr(cast(void*) this, GC.BlkAttr.NO_MOVE);
		settings = new Settings("technology.unrelenting.numbernine.Shell.applet.launcher",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/launcher/");
		root = new ToggleButton("");
		auto icon = new Image("system-search-symbolic", GtkIconSize.SMALL_TOOLBAR);
		root.setImage(icon);
		root.getStyleContext().addClass("n9-panel-launcher");
		root.setAlwaysShowImage(true);
		popover = new PanelPopover(root, panel);
		setupGlade();
		popover.popover.add(toplevel);
		toplevel.showAll();
		root.show();
		refreshLists();
		setAppResults(apps.values);
		resultfilter.setVisibleFunc(&launcherFilterFunc, cast(void*) this, null);
		resultsort.setDefaultSortFunc(&launcherSortFunc, cast(void*) this, null);
		resultview.addOnRowActivated((TreePath p, TreeViewColumn _, TreeView v) {
			popover.popover.popdown();
			TreeIter it = new TreeIter(resultsort, p);
			apps[it.getValueString(0)].launch(null, null);
		});
		searchbar.addOnSearchChanged((SearchEntry bar) {
			// TODO: plugin mode
			resultfilter.refilter();
			TreeIter it;
			resultsort.getIterFirst(it);
			resultview.getSelection().selectIter(it);
			resultview.scrollToCell(resultsort.getPath(it), null, false, 0.0, 0.0);
		});
		searchbar.addOnKeyPress((GdkEventKey* key, Widget _) {
			if (key.keyval == GdkKeysyms.GDK_Tab || key.keyval == GdkKeysyms.GDK_KP_Tab ||
				key.keyval == GdkKeysyms.GDK_ISO_Left_Tab) {
				return true;
			}
			void scrollTo(void delegate(ref TreeIter it) manip) {
				TreeIter it = resultview.getSelection().getSelected();
				manip(it);
				resultview.getSelection().selectIter(it);
				resultview.scrollToCell(resultsort.getPath(it), null, false, 0.0, 0.0);
			}

			if (key.keyval == GdkKeysyms.GDK_Up || key.keyval == GdkKeysyms.GDK_KP_Up) {
				scrollTo((ref TreeIter it) { resultsort.iterPrevious(it); });
				return true;
			}
			if (key.keyval == GdkKeysyms.GDK_Down || key.keyval == GdkKeysyms.GDK_KP_Down) {
				scrollTo((ref TreeIter it) { resultsort.iterNext(it); });
				return true;
			}
			if (key.keyval == GdkKeysyms.GDK_Return || key.keyval == GdkKeysyms.GDK_KP_Enter) {
				TreeModelIF m;
				auto sels = resultview.getSelection().getSelectedRows(m);
				if (sels.length < 1) {
					return false;
				}
				resultview.rowActivated(sels[0], resultview.getColumn(0));
				return true;
			}
			return false;
		});
		popover.afterOpen = () { searchbar.grabFocus(); };
		TreeIter it;
		resultsort.getIterFirst(it);
		resultview.getSelection().selectIter(it);
	}

	void setAppResults(R)(R results) {
		resultstore.clear();
		foreach (DesktopAppInfo app; results) {
			TreeIter it;
			resultstore.append(it);
			resultstore.setValue(it, 0, app.getId());
			auto appIcon = app.getIcon();
			if (appIcon) {
				// XXX: couldn't get GIcon column to work
				resultstore.setValue(it, 1, appIcon.toString());
			}
			resultstore.setValue(it, 2, "<b>" ~ app.getDisplayName() ~ "</b>" ~ (app.getGenericName()
					.length == 0 ? "" : " <span size=\"small\" weight=\"light\">(" ~ app.getGenericName() ~ ")</span>") ~ "\n" ~ app
					.getDescription() ~ " " ~ app.getKeywords()
					.map!(k => "<span size=\"small\" weight=\"light\">#" ~ k ~ "</span>").join(" "));
		}
	}

	void refreshLists() {
		apps.clear();
		cats.clear();
		foreach (app; DesktopAppInfo.getAll().toArray!DesktopAppInfo().filter!(x => x.shouldShow())) {
			apps[app.getId()] = app;
			foreach (cat; app.getCategories().split(";")) {
				if ((cat in cats) is null) {
					cats[cat] = [];
				}
				cats[cat] ~= app.getId();
			}
		}
	}

}
