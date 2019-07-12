module Glade;

struct ById {
	string id;
}

mixin template Glade(string res) {
	import gtk.Builder : Builder;

	Builder builder;

	this() {
		import std.traits : getUDAs;
		import std.algorithm : startsWith;

		builder = new Builder();
		builder.addFromResource(res);
		static foreach (mem; __traits(allMembers, typeof(this)))
			static foreach (ident; getUDAs!(__traits(getMember, typeof(this), mem), ById))
				__traits(getMember, this, mem) = cast(typeof(__traits(getMember, this, mem))) builder.getObject(
						ident.id);
		static foreach (mem; __traits(allMembers, typeof(this)))
			static if (startsWith(mem, "setup"))
				__traits(getMember, this, mem)();
	}
}

mixin template Css(string res, alias topl) {
	void setupCss() {
		import std.typecons : scoped;
		import gtk.c.types;
		import gdk.Screen : Screen;
		import gtk.CssProvider : CssProvider;

		auto css = scoped!CssProvider();
		css.loadFromResource(res);
		topl.getStyleContext().addProviderForScreen(Screen.getDefault(), css, GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
	}
}
