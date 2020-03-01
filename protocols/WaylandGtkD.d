module WaylandGtkD;
import gdk.Display;
import gtk.Main;
import std.stdio : writeln;
public import wayland.client.core;
public import wayland.client.protocol;
public import wayland.native.client;

extern (C) wl_display* gdk_wayland_display_get_wl_display(GdkDisplay*);
extern (C) wl_proxy* gdk_wayland_device_get_wl_seat(GdkDevice*);

WlDisplay wlGdkGetDisplay() {
	return new WlDisplay(gdk_wayland_display_get_wl_display(Display.getDefault().getDisplayStruct()));
}

T wlGdkGetGlobal(T)() {
	T glob = null;

	auto display = wlGdkGetDisplay();
	if (display is null) {
		writeln("ERROR: could not get wayland display");
		return null;
	}

	auto reg = display.getRegistry();
	scope (exit)
		reg.destroy();

	reg.onGlobal = (WlRegistry reg, uint name, string iface, uint ver) {
		if (iface == T.iface.name) {
			glob = cast(T) reg.bind(name, T.iface, ver);
		}
	};

	display.roundtrip();
	if (glob is null) {
		writeln("ERROR: could not get wayland global " ~ T.iface.name);
	}
	return glob;
}

WlSeat wlGdkGetSeat() {
	return new WlSeat(gdk_wayland_device_get_wl_seat(Main.getCurrentEventDevice().getDeviceStruct()));
}

void wlGdkRoundtrip() {
	auto display = wlGdkGetDisplay();
	if (display is null) {
		writeln("ERROR: could not get wayland display");
		return;
	}

	display.roundtrip();
}
