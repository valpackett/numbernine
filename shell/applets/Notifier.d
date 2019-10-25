module applets.Notifier;
import gtk.Widget;
import gtk.Label;
import gio.Settings;
import applets.Applet;
import NotificationServer;
import Global;

final class Notifier : Applet {
	int curId = -1;
	Label root;
	Settings settings;

	Widget rootWidget() {
		return root;
	}

	this(string name) {
		root = new Label("");
		root.getStyleContext().addClass("n9-panel-notifier");
		settings = new Settings("technology.unrelenting.numbernine.Shell.applet.notifier",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/notifier/");
		notifSrv.onAdd ~= (uint id) { root.setText(notifSrv.notifs[id].title); };
		notifSrv.onClose ~= (uint id) {
			if (curId != id)
				return;
			clear();
		};
	}

	void clear() {
		root.setText("");
		curId = -1;
	}
}
