module MultiMonitor;
import core.memory : GC;
import gdk.Display;
import gdk.MonitorG;

final class MultiMonitorRunner(T) {
	Display disp;
	T[MonitorG] objs;

	this() {
		disp = Display.getDefault();
		disp.addOnMonitorAdded(&onMonitorAdded);
		disp.addOnMonitorRemoved(&onMonitorRemoved);
		for (uint i = 0; i < disp.getNMonitors(); i++) {
			onMonitorAdded(disp.getMonitor(i), disp);
		}
	}

	void onMonitorAdded(MonitorG monitor, Display) {
		if ((monitor in objs) !is null) {
			return;
		}
		objs[monitor] = new T(monitor);
	}

	void onMonitorRemoved(MonitorG monitor, Display) {
		if ((monitor in objs) !is null) {
			objs.remove(monitor);
			GC.collect();
			GC.minimize();
		}
	}
}
