module NotificationServer;
import std.typecons : scoped, tuple;
import gio.DBusConnection;
import gio.DBusNames;
import gio.DBusNodeInfo;
import gio.DBusMethodInvocation;
import gobject.DClosure;
import glib.Variant;
import DBus;
import Vals;

struct Notification {
	uint id;
	string iconName;
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
		while (!((notif.id in notifs) is null))
			notif.id = uniform(0, uint.max, rndGen);
		notif.iconName = app_icon;
		notif.title = summary;
		notif.text = text;
		notifs[notif.id] = notif;
		foreach (cb; onAdd)
			cb(notif.id);
		invo.returnValue(toVariant(tuple(notif.id)));
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
