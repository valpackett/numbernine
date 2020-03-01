module applets.Dock;
import std.typecons : scoped;
import std.stdio : writeln;
import std.algorithm : remove;
import gtk.Widget;
import gtk.Box;
import gtk.Button;
import gtk.Image;
import gio.DesktopAppInfo;
import gio.AppInfoIF;
import gio.Settings;
import applets.Applet;
import WaylandGtkD : wlGdkGetSeat;
import WindowManager;
import Global;

final class DockedApp {
	string id;
	string name;
	string icon = "application-default-icon";
	bool persist = false;
	ZwlrForeignToplevelHandleV1[] windows;
	Box root;
	Button mainButton;
	Button[ZwlrForeignToplevelHandleV1] winButtons;

	void addWindow(ZwlrForeignToplevelHandleV1 hdl) {
		windows ~= hdl;
		if (windows.length > 1) {
			// TODO: special look?
			auto btn = new Button(icon, GtkIconSize.SMALL_TOOLBAR);
			btn.addOnClicked((Button) { hdl.activate(wlGdkGetSeat()); });
			root.add(btn);
			btn.showAll();
			winButtons[hdl] = btn;
		}
	}

	bool removeWindow(ZwlrForeignToplevelHandleV1 hdl) {
		windows = remove!(x => x.id() == hdl.id())(windows);
		if ((hdl in winButtons) !is null) {
			root.remove(winButtons[hdl]);
			winButtons.remove(hdl);
		}
		return windows.length == 0;
	}

	this(string id_) {
		id = id_;
		try {
			auto app = new DesktopAppInfo(id ~ ".desktop");
			if (app !is null) {
				name = app.getDisplayName();
				if (app.getIcon() !is null) {
					icon = app.getIcon().toString();
				}
			} else {
				name = id;
			}
		} catch (Exception e) {
			name = id;
		}
		root = new Box(GtkOrientation.HORIZONTAL, 0);
		root.getStyleContext().addClass("n9-panel-dock-app");
		mainButton = new Button(icon, GtkIconSize.SMALL_TOOLBAR);
		mainButton.addOnClicked(&onMainButton);
		root.add(mainButton);
	}

	void onMainButton(Button) {
		if (windows.length == 0) {
			try {
				new DesktopAppInfo(id ~ ".desktop").launch(null, null);
			} catch (Exception e) {
				// TODO: GUI alert
				writeln("Failed to launch: " ~ id);
			}
			return;
		}
		windows[0].activate(wlGdkGetSeat());
	}
}

final class Dock : Applet {
	Box root;
	Settings settings;
	DockedApp[string] apps;

	Widget rootWidget() {
		return root;
	}

	this(string name) {
		settings = new Settings("technology.unrelenting.numbernine.Shell.applet.dock",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/dock/");

		root = new Box(GtkOrientation.HORIZONTAL, 0);
		root.getStyleContext().addClass("n9-panel-dock");

		foreach (hdl, win; winMgr.windows) {
			ensureApp(win.appId);
			apps[win.appId].addWindow(hdl);
		}

		winMgr.onAdd ~= (ZwlrForeignToplevelHandleV1 hdl) {
			auto id = winMgr.windows[hdl].appId;
			ensureApp(id);
			apps[id].addWindow(hdl);
		};

		winMgr.onClose ~= (ZwlrForeignToplevelHandleV1 hdl) {
			auto id = winMgr.windows[hdl].appId;
			ensureApp(id);
			if (apps[id].removeWindow(hdl) && !apps[id].persist) {
				root.remove(apps[id].root);
				apps.remove(id);
			}
		};

		root.show();
	}

	void ensureApp(string id) {
		if ((id in apps) !is null)
			return;
		apps[id] = new DockedApp(id);
		root.add(apps[id].root);
		apps[id].root.showAll();
	}
}
