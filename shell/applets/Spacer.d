module applets.Spacer;
import gtk.Widget;
import gtk.Separator;
import gio.Settings;
import applets.Applet;

class Spacer : Applet {
	Separator root;
	Settings settings;

	Widget rootWidget() {
		return root;
	}

	this(string name) {
		root = new Separator(GtkOrientation.HORIZONTAL);
		root.getStyleContext().addClass("n9-panel-spacer");
		settings = new Settings("technology.unrelenting.numbernine.Shell.applet.spacer",
				"/technology/unrelenting/numbernine/Shell/applet/" ~ name ~ "/spacer/");
		settings.bindWritable("expand", root, "hexpand", false);
		root.setHexpand(settings.getBoolean("expand"));
	}
}
