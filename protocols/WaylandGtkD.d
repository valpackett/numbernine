module WaylandGtkD;
import gdk.Display;
public import wayland.client.core;
public import wayland.client.protocol;
public import wayland.native.client;

extern (C) wl_display* gdk_wayland_display_get_wl_display(GdkDisplay*);

final class WlDisplayGdk : WlDisplayBase {
	this(GdkDisplay* disp) {
		super(gdk_wayland_display_get_wl_display(disp));
	}

	// workaround protected/package visibility
	WlDisplay unwrap() {
		union U {
			WlDisplayGdk g;
			WlDisplay d;
		}

		return U(this).d;
	}
}
