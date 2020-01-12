module Wallpaper;
import core.memory : GC;
import std.typecons : scoped;
import lsh.LayerShell;
import gio.Settings;
import glib.GException;
import gdk.GLContext;
import gdkpixbuf.Pixbuf;
import gtk.Window;
import gtk.Widget;
import gtk.GLArea;

extern (C++) {
	void n9_wallpaper_setup();
	uint n9_wallpaper_upload_image(size_t, size_t, char*);
	void n9_wallpaper_deallocate_image(uint);
	void n9_wallpaper_render_blank();
	void n9_wallpaper_render_image(uint);
}

final class Wallpaper {
	Settings settings;
	Window toplevel;
	GLArea area;
	string filePath;

	this() {
		settings = new Settings("technology.unrelenting.numbernine.Shell");

		toplevel = new Window("Wallpaper");
		LayerShell.initForWindow(toplevel);
		LayerShell.setLayer(toplevel, GtkLayerShellLayer.BACKGROUND);
		LayerShell.setAnchor(toplevel, GtkLayerShellEdge.TOP, true);
		LayerShell.setAnchor(toplevel, GtkLayerShellEdge.RIGHT, true);
		LayerShell.setAnchor(toplevel, GtkLayerShellEdge.BOTTOM, true);
		LayerShell.setAnchor(toplevel, GtkLayerShellEdge.LEFT, true);
		LayerShell.setExclusiveZone(toplevel, -1);
		toplevel.setAppPaintable(true);

		area = new GLArea();
		area.setAutoRender(false);
		area.setUseEs(true);
		area.addOnRealize(&setupWallpaper);
		area.addOnRender(&renderWallpaper);
		toplevel.add(area);
		toplevel.showAll();

		settings.addOnChanged((string key, Settings _) {
			if (key == "wallpaper") {
				filePath = settings.getString("wallpaper");
				area.queueRender();
			}
		});
		filePath = settings.getString("wallpaper");
		area.queueRender();
	}

	void setupWallpaper(Widget) {
		area.makeCurrent();
		// TODO: check error
		n9_wallpaper_setup();
	}

	bool renderWallpaper(GLContext, GLArea) {
		try {
			auto pb = scoped!Pixbuf(filePath);
			if (pb is null) {
				n9_wallpaper_render_blank();
				return true;
			}
			// TODO: support crop, fit etc
			auto curTex = n9_wallpaper_upload_image(cast(size_t) pb.getWidth(),
					cast(size_t) pb.getHeight(), pb.getPixels());
			scope (exit)
				n9_wallpaper_deallocate_image(curTex);
			// make extra sure not to hog system memory
			pb.unref();
			GC.collect();
			GC.minimize();
			n9_wallpaper_render_image(curTex);
		} catch (GException e) {
			n9_wallpaper_render_blank();
		}
		return true;
	}
}
