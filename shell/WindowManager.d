module WindowManager;
import std.stdio : writeln;
import WaylandGtkD;
public import wlr_foreign_toplevel_management_unstable_v1;

final class Window {
	ZwlrForeignToplevelHandleV1 hdl = null;
	string title;
	string appId;

	this(ZwlrForeignToplevelHandleV1 hdl_) {
		hdl = hdl_;
		hdl.onTitle = (ZwlrForeignToplevelHandleV1, string title_) {
			title = title_;
		};
		hdl.onAppId = (ZwlrForeignToplevelHandleV1, string appId_) {
			appId = appId_;
		};
		wlGdkRoundtrip();
	}

	~this() {
		hdl.destroy();
	}
}

final class WindowManager {
	ZwlrForeignToplevelManagerV1 mgr = null;
	Window[ZwlrForeignToplevelHandleV1] windows;
	void delegate(ZwlrForeignToplevelHandleV1)[] onAdd;
	void delegate(ZwlrForeignToplevelHandleV1)[] onClose;

	this() {
		mgr = wlGdkGetGlobal!ZwlrForeignToplevelManagerV1();
		mgr.onToplevel = (ZwlrForeignToplevelManagerV1, ZwlrForeignToplevelHandleV1 hdl) {
			windows[hdl] = new Window(hdl);
			foreach (cb; onAdd)
				cb(hdl);
			hdl.onClosed = (ZwlrForeignToplevelHandleV1) {
				foreach (cb; onClose)
					cb(hdl);
				windows.remove(hdl);
			};
		};
	}
}
