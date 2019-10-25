module applets.Power;
import gtk.Widget;
import gtk.Box;
import gtk.Image;
import gio.Settings;
import gobject.Value;
import upower.Client;
import upower.Device;
import applets.Applet;
import Vals;

final class Power : Applet {
	Box root;
	Settings settings;
	Client client;

	Widget rootWidget() {
		return root;
	}

	this(string name) {
		root = new Box(GtkOrientation.HORIZONTAL, 2);
		root.getStyleContext().addClass("n9-panel-power");
		settings = new Settings("technology.unrelenting.numbernine.Shell.applet.power",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/power/");
		client = new Client();
		update();
	}

	// TODO: be more dynamic, support device add-remove
	void update() {
		if (!client) {
			//return;
		}

		auto devs = client.getDevices();
		for (uint i = 0; i < devs.len(); i++) {
			auto dev = new Device(cast(UpDevice*) devs.index(i));
			if (!getPropertyBool(dev, "is-rechargeable"))
				continue;
			auto wdg = new Image();
			root.add(wdg);
			wdg.show();
			dev.bindProperty("icon-name", wdg, "icon-name", GBindingFlags.SYNC_CREATE);
		}
	}
}
