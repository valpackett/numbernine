module lsh.c.types;

public import gdk.c.types;
public import gtk.c.types;


public enum GtkLayerShellEdge
{
	LEFT = 0,
	RIGHT = 1,
	TOP = 2,
	BOTTOM = 3,
	ENTRY_NUMBER = 4,
}
alias GtkLayerShellEdge Edge;

public enum GtkLayerShellLayer
{
	BACKGROUND = 0,
	BOTTOM = 1,
	TOP = 2,
	OVERLAY = 3,
	ENTRY_NUMBER = 4,
}
alias GtkLayerShellLayer Layer;
