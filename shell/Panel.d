module Panel;
import std.stdio : writeln;
import gdk.Event;
import gdk.MonitorG;
import gtk.Window;
import gtk.Widget;
import gtk.Box;
import gio.Settings;
import lsh.LayerShell;
import Glade;
import applets.Applet;
import applets.Clock;
import applets.Launcher;
import applets.Notifier;
import applets.Power;
import applets.Spacer;
import PanelPopover;

final class AppletHolder {
	string name;
	string curType;
	Applet applet;
	Box parent;
	Panel panel;
	Settings settings;

	this(string name_, Panel panel_, Box parent_) {
		name = name_;
		panel = panel_;
		parent = parent_;
		settings = new Settings("technology.unrelenting.numbernine.Shell.panel.applet",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/");
		settings.addOnChanged((string key, Settings _) {
			if (key == "applet-type")
				updateAppletType();
			else if (key == "position")
				updatePosition();
		});
		updateAppletType();
		updatePosition();
	}

	void remove() {
		if (!applet)
			return;
		parent.remove(applet.rootWidget());
	}

	void updatePosition() {
		if (!applet)
			return;
		parent.reorderChild(applet.rootWidget(), settings.getInt("position"));
	}

	void updateAppletType() {
		import std.string : split;

		auto newType = settings.getString("applet-type");
		if (newType == curType && applet)
			return;
		if (newType == "unknown")
			curType = name.split("-")[0];
		else
			curType = newType;
		remove();
		if (curType == "clock")
			applet = new Clock(name);
		else if (curType == "spacer")
			applet = new Spacer(name);
		else if (curType == "launcher")
			applet = new Launcher(name, panel);
		else if (curType == "notifier")
			applet = new Notifier(name, panel);
		else if (curType == "power")
			applet = new Power(name);
		if (!applet) {
			writeln("Unknown applet: " ~ curType ~ " for " ~ name);
			return;
		}
		writeln("Adding applet: " ~ curType ~ " for " ~ name);
		applet.rootWidget().getStyleContext().addClass("n9-panel-widget");
		parent.add(applet.rootWidget());
	}
}

final class Panel {
	Settings settings;
	Window toplevel;
	Box appletbox;
	AppletHolder[string] applets;
	PanelPopover activePopover;

	mixin Css!("/technology/unrelenting/numbernine/Shell/style.css", toplevel);

	this(string name, MonitorG monitor) {
		settings = new Settings("technology.unrelenting.numbernine.Shell.panel",
				"/technology/unrelenting/numbernine/Shell/panel/" ~ name ~ "/");

		if (!settings.getBoolean("initialized"))
			initWithDefaultWidgets();

		toplevel = new Window("Panel");
		LayerShell.initForWindow(toplevel);
		LayerShell.setMonitor(toplevel, monitor);
		LayerShell.setLayer(toplevel, GtkLayerShellLayer.TOP);
		LayerShell.setAnchor(toplevel, GtkLayerShellEdge.RIGHT, true);
		LayerShell.setAnchor(toplevel, GtkLayerShellEdge.BOTTOM, true);
		LayerShell.setAnchor(toplevel, GtkLayerShellEdge.LEFT, true);
		LayerShell.setExclusiveZone(toplevel, 18);
		// '$unfocus' is a Wayfire-specific magic word!!!
		LayerShell.setNamespace(toplevel, "$unfocus n9 shell panel");
		toplevel.setAppPaintable(true);
		toplevel.addOnFocusOut(&unfocus);

		setupCss();

		appletbox = new Box(GtkOrientation.HORIZONTAL, 2);
		appletbox.getStyleContext().addClass("n9-panel");
		toplevel.add(appletbox);
		appletbox.show();

		settings.addOnChanged((string key, Settings _) {
			if (key == "applets")
				updateApplets();
		});

		updateApplets();
	}

	bool unfocus(Event _, Widget w_) {
		if (activePopover)
			activePopover.popover.popdown();
		return true;
	}

	void updateApplets() {
		import std.algorithm : canFind;

		auto appletNames = settings.getStrv("applets");
		foreach (name; appletNames) {
			if ((name in applets) is null) {
				applets[name] = new AppletHolder(name, this, appletbox);
			}
		}
		foreach (name, _; applets) {
			if (!appletNames.canFind(name)) {
				applets[name].remove();
				applets.remove(name);
			}
		}
	}

	void initWithDefaultWidgets() {
		settings.setStrv("applets", ["clock-0", "power-0", "notifier-0", "spacer-0", "launcher-0"]);
		settings.setBoolean("initialized", true);
	}
}
