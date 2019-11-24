module applets.Launcher;
import std.array : split;
import std.algorithm.iteration : joiner, filter;
import std.algorithm.searching : canFind;
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

bool isMatched(string needle, DesktopAppInfo app) {
	return Fuzzy.hasMatch(needle, app.getDisplayName()) || Fuzzy.hasMatch(needle, app.getDescription());
}

double matchScore(string needle, DesktopAppInfo app) {
	double score = 0;
	if (Fuzzy.hasMatch(needle, app.getDisplayName())) {
		score += Fuzzy.match(needle, app.getDisplayName()) * 10;
	}
	if (Fuzzy.hasMatch(needle, app.getDescription())) {
		score += Fuzzy.match(needle, app.getDescription());
	}
	return score;
}

alias memMatchScore = memoize!(matchScore, 420);

extern (C) int launcherFilterFunc(GtkTreeModel* model, GtkTreeIter* iter, void* data) {
	auto launcher = cast(Launcher) data;
	auto it = new TreeIter(iter);
	it.setModel(model);
	auto needle = launcher.searchbar.getText();
	return isMatched(needle, launcher.apps[it.getValueString(0)]);
}

extern (C) int launcherSortFunc(GtkTreeModel* model, GtkTreeIter* a, GtkTreeIter* b, void* data) {
	auto launcher = cast(Launcher) data;
	auto itA = new TreeIter(a);
	auto itB = new TreeIter(b);
	itA.setModel(model);
	itB.setModel(model);
	auto needle = launcher.searchbar.getText();
	// import std.stdio : writeln;
	// writeln("A: ", itA.getValueString(0), " - ", memMatchScore(needle, launcher.apps[itA.getValueString(0)]));
	// writeln("B: ", itB.getValueString(0), " - ", memMatchScore(needle, launcher.apps[itB.getValueString(0)]));
	auto scoreDiff = memMatchScore(needle, launcher.apps[itA.getValueString(0)]) - memMatchScore(needle,
			launcher.apps[itB.getValueString(0)]);
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
		GC.setAttr(cast(void*) this, GC.BlkAttr.NO_MOVE);
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
			return false;
		});
		popover.afterOpen = () { searchbar.grabFocus(); };
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
			resultstore.setValue(it, 2, "<b>" ~ app.getDisplayName() ~ "</b>\n" ~ app.getDescription());
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
