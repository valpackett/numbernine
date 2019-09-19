module NotificationServer;
import std.typecons : scoped, tuple;
import gio.DBusConnection;
import gio.DBusNames;
import gio.DBusNodeInfo;
import gio.DBusMethodInvocation;
import gobject.DClosure;
import glib.Variant;
import gtk.Window;
import gtk.Box;
import gtk.EventBox;
import gtk.Image;
import gtk.Label;
import lsh.LayerShell;
import DBus;
import Vals;

/*
class Notification {
	@ById("toplevel") EventBox toplevel;
	@ById("icon") Image icon;
	@ById("title") Label title;
	@ById("title") Label body;

	mixin Glade!("/technology/unrelenting/numbernine/Shell/notification.glade");
	mixin Css!("/technology/unrelenting/numbernine/Shell/style.css", toplevel);
}
*/

struct Notification {
	uint id;
	string title;
	string text;
}

@BusInterface("org.freedesktop.Notifications")
final class NotificationServer {
	Notification[uint] notifs;
	void delegate(uint)[] onAdd;
	void delegate(uint)[] onClose;

	this() {
		DBusNames.ownNameWithClosures(GBusType.SESSION, "org.freedesktop.Notifications",
				GBusNameOwnerFlags.NONE, new DClosure((DBusConnection conn) {
					auto proto = scoped!DBusNodeInfo(import("org.freedesktop.Notifications.xml")).interfaces[0];
					DBusServer!NotificationServer.register(conn, proto, this, "/org/freedesktop/Notifications");
				}), null, null);
	}

	@BusMethod("Notify")
	void notify(string app_name, uint replaces_id, string app_icon, string summary, string text,
			string[] actions, Variant hints, int timeout, DBusMethodInvocation invo) {
		import std.random : uniform, rndGen;

		Notification notif;
		notif.id = uniform(0, uint.max, rndGen);
		notif.title = summary;
		notif.text = text;
		notifs[notif.id] = notif;
		foreach (cb; onAdd)
			cb(notif.id);
		invo.returnValue(toVariant(tuple(0u)));
	}

	@BusMethod("CloseNotification")
	void closeNotification(uint id, DBusMethodInvocation invo) {
		if ((id in notifs) is null) {
			invo.returnValue(null);
			return;
		}
		foreach (cb; onClose)
			cb(id);
		notifs.remove(id);
		invo.returnValue(null);
	}

	@BusMethod("GetCapabilities")
	void getCapabilities(DBusMethodInvocation invo) {
		invo.returnValue(toVariant(tuple(["actions", "body", "body-markup", "body-hyperlinks"])));
	}

	@BusMethod("GetServerInformation")
	void getServerInformation(DBusMethodInvocation invo) {
		invo.returnValue(toVariant(tuple("n9", "unrelenting.technology", "0.0", "0.0")));
	}
}
