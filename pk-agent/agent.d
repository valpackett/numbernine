import gio.Application;
import gio.DBusConnection;
import gio.DBusNames;
import gio.DBusNodeInfo;
import gio.DBusMethodInvocation;
import gobject.DClosure;
import glib.Variant;
import glib.Child;
import polkit.Authority;
import polkit.UnixSession;
import DBus;
import Vals;
import std.process;
import std.typecons;
import std.stdio;

extern (C) void onChildExit(int pid, int status, void* ptr) {
	auto agent = cast(Agent) ptr;
	string foundCookie = null;
	foreach (cookie, ref tup; agent.authReqs) {
		if (tup.dialogPid.osHandle == pid) {
			tup.reqInvo.returnValue(null);
			foundCookie = cookie;
			break;
		}
	}
	if (foundCookie != null) {
		agent.authReqs.remove(foundCookie);
	}
}

@BusInterface("org.freedesktop.PolicyKit1.AuthenticationAgent")
class Agent {
	Tuple!(DBusMethodInvocation, "reqInvo", Pid, "dialogPid")[string] authReqs;

	@BusMethod("BeginAuthentication")
	void BeginAuthentication(string actionId, string message, string iconName, Variant details,
			string cookie, Variant identities, DBusMethodInvocation invo) {
		// TODO: pass identity
		auto pid = spawnProcess(environment["N9_LIBEXEC_DIR"] ~ "/n9-pk-agent-dialog",
				[
					"N9_PK_ACTION_ID": actionId,
					"N9_PK_MESSAGE": message,
					"N9_PK_ICON_NAME": iconName,
					"N9_PK_COOKIE": cookie
				]).nullable;
		Child.childWatchAdd(pid.get.osHandle, &onChildExit, cast(void*) this);
		authReqs[cookie] = tuple(invo, pid);
	}

	@BusMethod("CancelAuthentication")
	void CancelAuthentication(string cookie, DBusMethodInvocation invo) {
		auto tup = cookie in authReqs;
		if (tup !is null) {
			import core.sys.posix.signal : SIGTERM;

			kill(tup.dialogPid, SIGTERM);
		}
		invo.returnValue(null);
	}
}

int main(string[] args) {
	const appname = "technology.unrelenting.numbernine.Agent"; // name on both busses
	const buspath = "/technology/unrelenting/numbernine/Agent"; // path on system bus
	auto app = scoped!Application(appname, GApplicationFlags.FLAGS_NONE);
	auto protoAgent = scoped!DBusNodeInfo(import("org.freedesktop.PolicyKit1.AuthenticationAgent.xml")).interfaces[0];
	app.addOnActivate(delegate(Application a) {
		DBusNames.ownNameWithClosures(GBusType.SYSTEM, "technology.unrelenting.numbernine.Agent",
			GBusNameOwnerFlags.NONE, new DClosure(delegate void(DBusConnection sysconn) {
				auto agent = new Agent();
				DBusServer!Agent.register(sysconn, protoAgent, agent, buspath);
				auto authority = Authority.getSync(null);
				auto session = new UnixSession(thisProcessID, null);
				authority.registerAuthenticationAgentSync(session, "en_US.UTF-8", buspath, null);
			}), null, null);
	});
	app.hold();
	return app.run(args);
}
