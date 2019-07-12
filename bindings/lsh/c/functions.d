module lsh.c.functions;

import std.stdio;
import lsh.c.types;
version (Windows)
	static immutable LIBRARY_LSH = ["shell.dll;shell.dll;shell.dll"];
else version (OSX)
	static immutable LIBRARY_LSH = ["shell.dylib"];
else
	static immutable LIBRARY_LSH = ["libgtk-layer-shell.so"];

__gshared extern(C)
{

	// lsh.LayerShell

	void gtk_layer_init_for_window(GtkWindow* window);
	void gtk_layer_set_namespace(GtkWindow* window, const(char)* nameSpace);
	void gtk_layer_set_layer(GtkWindow* window, GtkLayerShellLayer layer);
	void gtk_layer_set_monitor(GtkWindow* window, GdkMonitor* monitor);
	void gtk_layer_set_anchor(GtkWindow* window, GtkLayerShellEdge edge, int anchorToEdge);
	void gtk_layer_set_margin(GtkWindow* window, GtkLayerShellEdge edge, int marginSize);
	void gtk_layer_set_exclusive_zone(GtkWindow* window, int exclusiveZone);
	void gtk_layer_auto_exclusive_zone_enable(GtkWindow* window);
	void gtk_layer_set_keyboard_interactivity(GtkWindow* window, int interacitvity);
}