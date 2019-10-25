module applets.Clock;
import std.typecons : scoped;
import gtk.Widget;
import gtk.Label;
import gio.Settings;
import glib.Timeout;
import glib.DateTime;
import glib.c.functions;
import applets.Applet;

final class Clock : Applet {
	Label root;
	Timeout timer;
	Settings settings;

	Widget rootWidget() {
		return root;
	}

	this(string name) {
		settings = new Settings("technology.unrelenting.numbernine.Shell.applet.clock",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/clock/");

		root = new Label("__:__");
		root.getStyleContext().addClass("n9-panel-clock");
		timer = new Timeout(30 * 1000, delegate() {
			auto dt = scoped!DateTime(g_date_time_new_now_local());
			root.setText(dt.format("%H:%M"));
			import std.stdio;

			writeln(dt.format("tick %H:%M:%S"));
			return true;
		}, true);

		root.show();
	}
}
