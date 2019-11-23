module applets.Notifier;
import gtk.Widget;
import gtk.Label;
import gtk.Button;
import gtk.ToggleButton;
import gtk.Image;
import gtk.Box;
import gtk.Grid;
import gtk.ScrolledWindow;
import gio.Settings;
import glib.Timeout;
import applets.Applet;
import PanelPopover;
import Panel;
import NotificationServer;
import Global;
import Glade;

final class Notification {
	@ById("toplevel") Grid toplevel;
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
	ToggleButton root;
	Settings settings;
	PanelPopover popover;
	Box notifList;
	Timeout curClearer;

	Widget rootWidget() {
		return root;
	}

	this(string name, Panel panel) {
		settings = new Settings("technology.unrelenting.numbernine.Shell.applet.notifier",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/notifier/");
		root = new ToggleButton("");
		auto icon = new Image("dialog-warning-symbolic", GtkIconSize.SMALL_TOOLBAR);
		root.setImage(icon);
		root.getStyleContext().addClass("n9-panel-notifier");
		root.setImagePosition(GtkPositionType.RIGHT);
		root.setAlwaysShowImage(true);
		popover = new PanelPopover(root, panel);
		popover.onOpen = () { root.setLabel(""); };
		auto sw = new ScrolledWindow();
		notifList = new Box(GtkOrientation.VERTICAL, 5);
		notifList.setValign(GtkAlign.START);
		sw.add(notifList);
		sw.showAll();
		popover.popover.add(sw);
		notifSrv.onAdd ~= &addNotif;
		notifSrv.onClose ~= &closeNotif;
	}

	void addNotif(uint id) {
		root.show();
		newestNotif = id;
		notifs[id] = new Notification();
		notifs[id].icon.setFromIconName(notifSrv.notifs[id].iconName, GtkIconSize.DIALOG);
		notifs[id].title.setText(notifSrv.notifs[id].title);
		notifs[id].body.setText(notifSrv.notifs[id].text);
		notifs[id].close.addOnClicked((Button _) { closeNotif(id); });
		notifList.packStart(notifs[id].toplevel, false, false, 0);
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
