import gio.Application : GioApplication = Application;
import gtk.Application;
import std.stdio;
import std.typecons;
import Global;

int main(string[] args) {
	auto app = scoped!Application("technology.unrelenting.numbernine.Shell", GApplicationFlags.FLAGS_NONE);
	app.addOnActivate((GioApplication a) {
		notifSrv = new NotificationServer();
		panelMgr = new MultiMonitorRunner!PanelManager();
		wallpaper = new MultiMonitorRunner!Wallpaper();
	});
	app.hold();
	return app.run(args);
}
