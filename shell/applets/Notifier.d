module applets.Notifier;
import gtk.Widget;
import gtk.Label;
import gtk.Button;
import gtk.Image;
import gtk.Popover;
import gtk.Box;
import gtk.EventBox;
import gtk.ScrolledWindow;
import gio.Settings;
import glib.Timeout;
import applets.Applet;
import NotificationServer;
import Global;
import Glade;

final class Notification {
	@ById("toplevel") EventBox toplevel;
	@ById("icon") Image icon;
	@ById("title") Label title;
	@ById("body") Label body;
	@ById("close") Button close;

	mixin Glade!("/technology/unrelenting/numbernine/Shell/applets/NotifierNotification.glade");
	mixin Css!("/technology/unrelenting/numbernine/Shell/style.css", toplevel);
}

final class Notifier : Applet {
	Notification[uint] notifs;
	uint newestNotif = 0;
	Button root;
	Settings settings;
	Popover popover;
	Box notifList;
	Timeout curClearer;

	Widget rootWidget() {
		return root;
	}

	this(string name) {
		settings = new Settings("technology.unrelenting.numbernine.Shell.applet.notifier",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/notifier/");
		root = new Button("dialog-warning-symbolic", GtkIconSize.SMALL_TOOLBAR);
		root.getStyleContext().addClass("n9-panel-notifier");
		root.setImagePosition(GtkPositionType.RIGHT);
		root.setAlwaysShowImage(true);
		popover = new Popover(root);
		popover.setSizeRequest(420, 420);
		auto sw = new ScrolledWindow();
		notifList = new Box(GtkOrientation.VERTICAL, 5);
		sw.add(notifList);
		popover.add(sw);
		notifSrv.onAdd ~= &addNotif;
		notifSrv.onClose ~= &closeNotif;
		root.addOnClicked((Button _) { popover.showAll(); });
	}

	void addNotif(uint id) {
		root.show();
		newestNotif = id;
		notifs[id] = new Notification();
		notifs[id].title.setText(notifSrv.notifs[id].title);
		notifs[id].body.setText(notifSrv.notifs[id].text);
		notifs[id].close.addOnClicked((Button _) { closeNotif(id); });
		notifList.add(notifs[id].toplevel);
		root.setLabel(notifSrv.notifs[id].title);
		if (curClearer)
			curClearer.stop();
		curClearer = new Timeout(3 * 1000, () { root.setLabel(""); curClearer = null; return false; }, false);
	}

	void closeNotif(uint id) {
		if ((id in notifs) is null)
			return;
		notifList.remove(notifs[id].toplevel);
		notifs.remove(id);
		if (id == newestNotif)
			root.setLabel("");
		if (notifs.length == 0)
			root.hide();
	}
}
