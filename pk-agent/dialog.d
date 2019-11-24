import gio.Application : GioApplication = Application;
import gtk.Application;
import gtk.Window;
import gtk.EventBox;
import gtk.Box;
import gtk.Label;
import gtk.Entry;
import gtk.Button;
import gdk.Keysyms;
import gdk.Display;
import gobject.Signals;
import glib.Variant;
import glib.Child;
import lsh.LayerShell;
import polkit.UnixUser;
import polkitagent.Session;
import wl_protos;
import Glade;
import Vals;
import std.process : environment;
import std.typecons;
import std.stdio;

class DialogApp {
	Session session;
	Window window;
	EventBox wrapper;
	@ById("toplevel") Box toplevel;
	@ById("message") Label message;
	@ById("prompt") Label prompt;
	@ById("identity") Label identity;
	@ById("input") Entry input;
	@ById("deny") Button denyBtn;
	@ById("allow") Button allowBtn;

	mixin Glade!("/technology/unrelenting/numbernine/pk-agent/auth.glade");
	mixin AutoThis!();

	void setupDialog() {
		// TODO: multi-monitor
		window = new Window("Auth dialog");
		LayerShell.initForWindow(window);
		LayerShell.setLayer(window, GtkLayerShellLayer.OVERLAY);
		LayerShell.setAnchor(window, GtkLayerShellEdge.TOP, true);
		LayerShell.setAnchor(window, GtkLayerShellEdge.RIGHT, true);
		LayerShell.setAnchor(window, GtkLayerShellEdge.BOTTOM, true);
		LayerShell.setAnchor(window, GtkLayerShellEdge.LEFT, true);
		LayerShell.setKeyboardInteractivity(window, true);
		window.setAppPaintable(true);

		toplevel.setValign(GtkAlign.CENTER);
		toplevel.setHalign(GtkAlign.CENTER);
		wrapper = new EventBox();
		wrapper.getStyleContext().addClass("n9-polkit-transparent-wrapper");
		wrapper.setAboveChild(false);
		wrapper.add(toplevel);
		window.add(wrapper);

		allowBtn.addOnClicked(delegate void(Button) { allow(); });
		denyBtn.addOnClicked(delegate void(Button) { deny(); });
		input.addOnKeyRelease(delegate bool(GdkEventKey* key, Widget) {
			if (key.keyval == GdkKeysyms.GDK_Return || key.keyval == GdkKeysyms.GDK_KP_Enter ||
				key.keyval == GdkKeysyms.GDK_ISO_Enter) {
				allow();
				return true;
			}
			return false;
		});

		message.setText(environment["N9_PK_MESSAGE"]);
	}

	void deny() {
		session.cancel();
	}

	void allow() {
		session.response(input.getText());
	}

	mixin Css!("/technology/unrelenting/numbernine/pk-agent/style.css", window);

	zwlr_input_inhibitor_v1 *inhibitor = null;

	void connect() {
		import core.sys.posix.unistd : getuid;

		// TODO: get identity via env
		auto ident = new UnixUser(getuid());
		session = new Session(ident, environment["N9_PK_COOKIE"]);
		session.addOnCompleted(delegate void(bool result, Session) {
			// TODO: nicer exit?
			import core.sys.posix.stdlib : exit;

			if (inhibitor != null) {
				zwlr_input_inhibitor_v1_destroy(inhibitor);
				inhibitor = null;
			}
			exit(0);
		});
		session.addOnRequest(delegate void(string req, bool, Session) {
			prompt.setText(req);
			window.showAll();
			if (!wl_protos_get_for_gdk(Display.getDefault().getDisplayStruct())) {
				writeln("WARN: could not get wayland protocols");
				return;
			}
			inhibitor = zwlr_input_inhibit_manager_v1_get_inhibitor(wl_protos_input_inhibit_manager);
			if (inhibitor == null)
				writeln("WARN: could not inhibit input");
		});
		// TODO: show these on the dialog?
		session.addOnShowError(delegate void(string err, Session) { writeln("err: ", err); });
		session.addOnShowInfo(delegate void(string inf, Session) { writeln("info: ", inf); });
		session.initiate();
	}
}

int main(string[] args) {
	auto app = scoped!Application("technology.unrelenting.numbernine.AuthDialog", GApplicationFlags.FLAGS_NONE);
	app.addOnActivate(delegate(GioApplication a) { new DialogApp().connect(); });
	app.hold();
	return app.run(args);
}
