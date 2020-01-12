module applets.Launcher;
import std.algorithm : filter;
import gtk.Widget;
import gtk.Label;
import gtk.Button;
import gtk.ToggleButton;
import gtk.Image;
import gtk.Box;
import gtk.Grid;
import gtk.ScrolledWindow;
import gtk.ListStore;
import gtk.TreeModelIF;
import gtk.TreeView;
import gtk.TreeViewColumn;
import gtk.TreeIter;
import gtk.TreePath;
import gtk.SearchEntry;
import gdk.Keysyms;
import gio.Settings;
import gobject.Value;
import gobject.ObjectG;
import applets.Applet;
import launcher_plugins.Plugin;
import launcher_plugins.Apps;
import launcher_plugins.Calculator;
import PanelPopover;
import Panel;
import Global;
import Glade;

final class Launcher : Applet {
	ToggleButton root;
	Settings settings;
	PanelPopover popover;

	@ById("toplevel") Grid toplevel;
	@ById("resultview") TreeView resultview;
	@ById("searchbar") SearchEntry searchbar;

	mixin Glade!("/technology/unrelenting/numbernine/Shell/applets/Launcher.glade");
	mixin Css!("/technology/unrelenting/numbernine/Shell/style.css", toplevel);

	Plugin[] plugins;
	Plugin currentPlugin;

	void setupPlugins() {
		plugins ~= new Calculator();
		currentPlugin = new Apps();
		plugins ~= currentPlugin;
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
		setupPlugins();
		popover.popover.add(toplevel);
		toplevel.showAll();
		root.show();
		resultview.addOnRowActivated((TreePath p, TreeViewColumn c, TreeView v) {
			popover.popover.popdown();
			currentPlugin.activateRow(p, c, v);
		});
		searchbar.addOnSearchChanged((SearchEntry bar) {
			auto f = plugins.filter!(p => p.matchesSearch(bar.getText()));
			if (f.empty) {
				return;
			}
			currentPlugin = f.front;
			currentPlugin.updateResults(bar.getText());
			TreeModelIF model = currentPlugin.getResultModel();
			resultview.setModel(model);
			TreeIter it;
			model.getIterFirst(it);
			resultview.getSelection().selectIter(it);
			resultview.scrollToCell(model.getPath(it), null, false, 0.0, 0.0);
		});
		searchbar.addOnKeyPress((GdkEventKey* key, Widget _) {
			if (key.keyval == GdkKeysyms.GDK_Tab || key.keyval == GdkKeysyms.GDK_KP_Tab ||
				key.keyval == GdkKeysyms.GDK_ISO_Left_Tab) {
				return true;
			}
			void scrollTo(bool delegate(ref TreeIter it) manip) {
				TreeIter it = resultview.getSelection().getSelected();
				if (!manip(it)) {
					return;
				}
				resultview.getSelection().selectIter(it);
				resultview.scrollToCell(resultview.getModel().getPath(it), null, false, 0.0, 0.0);
			}

			if (key.keyval == GdkKeysyms.GDK_Up || key.keyval == GdkKeysyms.GDK_KP_Up) {
				scrollTo((ref TreeIter it) { return resultview.getModel().iterPrevious(it); });
				return true;
			}
			if (key.keyval == GdkKeysyms.GDK_Down || key.keyval == GdkKeysyms.GDK_KP_Down) {
				scrollTo((ref TreeIter it) { return resultview.getModel().iterNext(it); });
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
		currentPlugin.updateResults(searchbar.getText());
		resultview.setModel(currentPlugin.getResultModel());
		TreeIter it;
		resultview.getModel().getIterFirst(it);
		resultview.getSelection().selectIter(it);
	}

}
