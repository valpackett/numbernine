module DBus;

import gio.DBusConnection;
import gio.DBusInterfaceInfo;
import gio.DBusMethodInvocation;
import gobject.DClosure;
import glib.Variant;
import Vals;
import std.traits : getUDAs, Parameters, ReturnType;
import std.typecons : Tuple;

struct BusInterface {
	string iface;
}

struct BusMethod {
	string name;
}

template DBusServer(T) {
	static string iface = getUDAs!(T, BusInterface)[0].iface;

	void register(DBusConnection conn, DBusInterfaceInfo ifinfo, T instance, string path) {
		conn.registerObjectWithClosures(path, ifinfo, new DClosure(delegate void(DBusConnection conn, string sender,
				string object_path, string interface_name, string method_name, Variant params,
				DBusMethodInvocation invo) {
				static foreach (mem; __traits(allMembers, T))
					static foreach (meth; getUDAs!(__traits(getMember, T, mem), BusMethod))
						if (method_name == meth.name) {
							Tuple!(Parameters!(__traits(getMember, T, mem))) args;
							static foreach (i, argtyp; Parameters!(__traits(getMember, T, mem))) {
								static if (is(argtyp == DBusMethodInvocation))
									args[i] = invo;
								else
									args[i] = params.getChildValue(i).toDVal!(argtyp);
							}

							__traits(getMember, instance, mem)(args.expand);
						}

			}), null, null);
	}
}
