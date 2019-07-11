module Vals;

import glib.Variant;
import std.typecons : Tuple;

pragma(inline, true) T toDVal(T)(Variant v) {
	static if (is(T == Variant))
		return v;
	else static if (is(T == string)) {
		size_t dummy;
		return v.getString(dummy);
	} else static if (is(T == char[]))
		return v.getBytestring(dummy);
	else static if (is(T == bool))
		return v.getBoolean();
	else static if (is(T == ubyte))
		return v.getByte();
	else static if (is(T == double))
		return v.getDouble();
	else static if (is(T == short))
		return v.getInt16();
	else static if (is(T == ushort))
		return v.getUint16();
	else static if (is(T == int))
		return v.getInt32();
	else static if (is(T == uint))
		return v.getUint32();
	else static if (is(T == long))
		return v.getInt64();
	else static if (is(T == ulong))
		return v.getUint64();
	else static if (is(T : Tuple!Args, Args...)) {
		Tuple!Args result;
		static foreach (i, typ; result.Types)
			result[i] = toDVal!(typ)(v.getChildValue(i));
		return result;
	} else static if (is(T : M[], M)) {
		T result;
		result.length = v.nChildren();
		foreach (ulong i; 0 .. v.nChildren())
			result[i] = toDVal!(M)(v.getChildValue(i));
		return result;
	}
}

pragma(inline, true) Variant toVariant(T)(T v) {
	import std.string;
	static if (is(T == Variant))
		return v;
	else static if (is(T == string))
		if (v == "") // null
			return new Variant(""); // actual empty string
		else
			return new Variant(v);
	else static if (is(T == bool) || is(T == ubyte) || is(T == double) || is(T == short) ||
			is(T == ushort) || is(T == int) || is(T == uint) || is(T == long) || is(T == ulong))
		return new Variant(v);
	else static if (is(T : Tuple!Args, Args...)) {
		Variant[] children;
		children.length = v.Types.length;
		static foreach (i, typ; v.Types)
			children[i] = toVariant!(typ)(v[i]);
		return new Variant(children);
	} else static if (is(T : M[], M)) {
		Variant[] children;
		children.length = v.length;
		foreach (i, val; v)
			children[i] = toVariant!(M)(val);
		return new Variant(children[0].getType(), children);
	}
}
