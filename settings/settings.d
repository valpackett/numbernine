import gio.Application : GioApplication = Application;
import gio.Settings;
import gio.SimpleAction;
import gtk.Application;
import gtk.ApplicationWindow;
import gtk.Adjustment;
import gtk.Switch;
import gtk.ComboBoxText;
import gtk.Window;
import gtk.Button;
import gtk.Revealer;
import gtk.HeaderBar;
import gtk.Stack;
import gtk.StackSidebar;
import gtk.FileChooserButton;
import gtk.ListBox;
import gtk.TreeView;
import gtk.ListStore;
import gtk.TreeIter;
import gobject.Signals;
import handy.Leaflet;
import KeyboardLayout;
import Glade;
import Vals;
import std.stdio;
import std.typecons;
import std.format;
import std.algorithm : remove;

// Widgets annotated with this will get bound to GSettings
struct Setting {
	string gset;
	string setting;
	string prop;
}

mixin template PageAppearance() {
	@ById("sa_appear_wp_picture_chooser") FileChooserButton picChooser;

	void setupAppearance() {
		picChooser.addOnFileSet(delegate void(FileChooserButton) {
			shell.setString("wallpaper", picChooser.getFilename());
		});
	}

	void updateAppearance() {
		picChooser.selectFilename(shell.getString("wallpaper"));
	}
}

mixin template PageMouse() {
	@ById("adj-mouse-speed") @Setting("input", "mouse-cursor-speed", "value") Adjustment mouseSpeed;
	@ById("adj-mouse-scroll-speed") @Setting("input", "mouse-scroll-speed", "value") Adjustment mouseScrollSpeed;
	@ById("adj-touchpad-speed") @Setting("input", "touchpad-cursor-speed", "value") Adjustment touchpadSpeed;
	@ById("adj-touchpad-scroll-speed") @Setting("input", "touchpad-scroll-speed", "value") Adjustment touchpadScrollSpeed;
	@ById("toggle-natural-scrolling") @Setting("input", "natural-scroll", "active") Switch touchpadNatScroll;
	@ById("toggle-tap-click") @Setting("input", "tap-to-click", "active") Switch touchpadTapClick;
	@ById("choose-click-method") @Setting("input", "click-method", "active-id") ComboBoxText touchpadClickMethod;
	@ById("choose-scroll-method") @Setting("input", "scroll-method", "active-id") ComboBoxText touchpadScrollMethod;
	@ById("toggle-touchpad-dwt") @Setting("input", "disable-while-typing", "active") Switch touchpadDwt;
	@ById("toggle-dwmouse") @Setting("input", "disable-touchpad-while-mouse", "active") Switch touchpadDwmouse;

}

mixin template PageKeyboard() {
	@ById("store-layouts") ListStore curLayoutStore;
	@ById("tree-layouts") TreeView curLayoutTree;
	@ById("adj-repeat-rate") @Setting("input", "kb-repeat-rate", "value") Adjustment kbRepeatRate;
	@ById("adj-repeat-delay") @Setting("input", "kb-repeat-delay", "value") Adjustment kbRepeatDelay;
	@ById("toggle-ctrl-as-esc") @Setting("mod2key", "ctrl-as-esc", "active") Switch ctrlAsEsc;
	@ById("toggle-shifts-as-parens") @Setting("mod2key", "shifts-as-parens", "active") Switch shiftsAsParens;

	XkbLayout[string] layouts;
	XkbGroup[string] optgroups; // TODO use this

	void setupKeyboard() {
		loadLayouts(layouts);

		updateKeyboard();

		auto actAdd = new SimpleAction("add-keyboard-layout", null);
		actAdd.addOnActivate(delegate void(Variant, SimpleAction) {
			auto dialog = new AddLayoutDialog();
			dialog.setLayouts(layouts);
			dialog.dialog.setTransientFor(toplevel);
			if (dialog.dialog.run() == GtkResponseType.OK) {
				dialog.addToSettings(input);
			}
			dialog.dialog.destroy();
		});
		toplevel.addAction(actAdd);

		auto actRemove = new SimpleAction("remove-keyboard-layout", null);
		actRemove.addOnActivate(delegate void(Variant, SimpleAction) {
			auto iter = curLayoutTree.getSelectedIter();
			if (iter is null)
				return;
			auto xkb = getXkb(input);
			auto idx = iter.getTreePath().getIndices()[0];
			xkb.layouts = xkb.layouts.remove(idx);
			xkb.variants = xkb.variants.remove(idx);
			setXkb(input, xkb);
		});
		toplevel.addAction(actRemove);
	}

	void updateKeyboard() {
		import std.range : lockstep;

		curLayoutStore.clear();
		auto xkb = getXkb(input);
		foreach (ref layout_key, variant_key; lockstep(xkb.layouts, xkb.variants)) {
			auto layout = layouts.get(layout_key, XkbLayout(format("[UNKNOWN] %s", layout_key), null));
			auto variant = layout.variants.get(variant_key, "Default");
			TreeIter row;
			curLayoutStore.append(row);
			curLayoutStore.setValue(row, 0, format("%s\n<span size='smaller'>%s</span>", layout.desc, variant));
		}
	}
}

class SettingsApp {
	Settings input;
	Settings mod2key;
	Settings shell;

	@ById("sa_toplevel") ApplicationWindow toplevel;

	// Header
	@ById("sa_header_back") Button headerBack;
	@ById("sa_header_back_revealer") Revealer headerBackRevealer;
	@ById("sa_header_leaflet") Leaflet headerLeaflet;
	@ById("sa_header_bar_main") HeaderBar headerBarMain;
	@ById("sa_header_bar_sidebar") HeaderBar headerBarSidebar;

	// Window content
	@ById("sa_top_leaflet") Leaflet topLeaflet;
	@ById("sa_top_stack_sidebar") StackSidebar topStackSidebar;
	@ById("sa_top_stack") Stack topStack;

	mixin Glade!("/technology/unrelenting/numbernine/settings/settings.glade");
	mixin Css!("/technology/unrelenting/numbernine/settings/style.css", toplevel);
	mixin AutoThis!();

	// Do not include pages before setupSettings -- setup* are auto-called in order
	void setupSettings() {
		input = new Settings("org.wayfire.plugin.input");
		input.addOnChanged(delegate void(string, Settings) { callUpdates(); });
		mod2key = new Settings("org.wayfire.plugin.mod2key");
		mod2key.addOnChanged(delegate void(string, Settings) { callUpdates(); });
		shell = new Settings("technology.unrelenting.numbernine.Shell");
		shell.addOnChanged(delegate void(string, Settings) { callUpdates(); });
	}

	mixin PageAppearance!();
	mixin PageMouse!();
	mixin PageKeyboard!();

	void callUpdates() {
		import std.algorithm : startsWith;

		static foreach (mem; __traits(allMembers, typeof(this)))
			static if (startsWith(mem, "update"))
				__traits(getMember, this, mem)();
	}

	void setupAnnotBinds() {
		import std.traits : getUDAs;

		static foreach (mem; __traits(allMembers, typeof(this)))
			static foreach (sett; getUDAs!(__traits(getMember, typeof(this), mem), Setting))
				__traits(getMember, this, sett.gset).bind(sett.setting, __traits(getMember, this,
						mem), sett.prop, GSettingsBindFlags.DEFAULT);
	}

	void setupLeaflet() {
		// XXX: xml builder supports bindings, but glade erases them on saving
		// https://source.puri.sm/Librem5/libhandy/issues/12 -- probably an issue about this
		// TODO: recheck
		headerLeaflet.bindProperty("folded", headerBackRevealer, "reveal-child", GBindingFlags.SYNC_CREATE);
		headerLeaflet.bindProperty("folded", headerBarSidebar, "show-close-button", GBindingFlags.SYNC_CREATE);
		const bidi = GBindingFlags.BIDIRECTIONAL | GBindingFlags.SYNC_CREATE;
		headerLeaflet.bindProperty("visible-child-name", topLeaflet, "visible-child-name", bidi);
		headerLeaflet.bindProperty("mode-transition-duration", headerBackRevealer, "transition-duration", bidi);
		headerLeaflet.bindProperty("child-transition-duration", topLeaflet, "child-transition-duration", bidi);
		headerLeaflet.bindProperty("child-transition-type", topLeaflet, "child-transition-type", bidi);
		headerLeaflet.bindProperty("mode-transition-duration", topLeaflet, "mode-transition-duration", bidi);
		headerLeaflet.bindProperty("mode-transition-type", topLeaflet, "mode-transition-type", bidi);

		updateTitle();
		Signals.connect(topStack, "notify::visible-child", &updateTitle);

		headerBack.addOnClicked(delegate void(Button) {
			headerLeaflet.setVisibleChildName("sidebar");
		});
	}

	void setupRunFirstUpdate() {
		callUpdates();
	}

	void updateTitle() {
		import gobject.Value;

		auto title = scoped!Value("");
		topStack.childGetProperty(topStack.getVisibleChild(), "title", title);
		headerBarMain.setTitle(title.getString());
		headerLeaflet.setVisibleChildName("content");
	}
}

//__gshared extern(C) string[] rt_options = [ "trapExceptions=0" ];
__gshared extern (C) bool hdy_init(int* argc, char*** argv);

shared static this() {
	hdy_init(null, null);
}

int main(string[] args) {
	auto app = scoped!Application("technology.unrelenting.numbernine.settings", GApplicationFlags.FLAGS_NONE);
	app.addOnActivate(delegate(GioApplication a) {
		auto sett = new SettingsApp();
		sett.toplevel.setApplication(app);
		sett.toplevel.showAll();
	});
	return app.run(args);
}
