module lsh.LayerShell;

private import gdk.MonitorG;
private import glib.Str;
private import gtk.Window;
private import lsh.c.functions;
public  import lsh.c.types;


/** */
public struct LayerShell
{

	/** */
	public static void initForWindow(Window window)
	{
		gtk_layer_init_for_window((window is null) ? null : window.getWindowStruct());
	}

	/** */
	public static void setNamespace(Window window, string nameSpace)
	{
		gtk_layer_set_namespace((window is null) ? null : window.getWindowStruct(), Str.toStringz(nameSpace));
	}

	/** */
	public static void setLayer(Window window, GtkLayerShellLayer layer)
	{
		gtk_layer_set_layer((window is null) ? null : window.getWindowStruct(), layer);
	}

	/** */
	public static void setMonitor(Window window, MonitorG monitor)
	{
		gtk_layer_set_monitor((window is null) ? null : window.getWindowStruct(), (monitor is null) ? null : monitor.getMonitorGStruct());
	}

	/** */
	public static void setAnchor(Window window, GtkLayerShellEdge edge, bool anchorToEdge)
	{
		gtk_layer_set_anchor((window is null) ? null : window.getWindowStruct(), edge, anchorToEdge);
	}

	/** */
	public static void setMargin(Window window, GtkLayerShellEdge edge, int marginSize)
	{
		gtk_layer_set_margin((window is null) ? null : window.getWindowStruct(), edge, marginSize);
	}

	/** */
	public static void setExclusiveZone(Window window, int exclusiveZone)
	{
		gtk_layer_set_exclusive_zone((window is null) ? null : window.getWindowStruct(), exclusiveZone);
	}

	/** */
	public static void autoExclusiveZoneEnable(Window window)
	{
		gtk_layer_auto_exclusive_zone_enable((window is null) ? null : window.getWindowStruct());
	}

	/** */
	public static void setKeyboardInteractivity(Window window, bool interacitvity)
	{
		gtk_layer_set_keyboard_interactivity((window is null) ? null : window.getWindowStruct(), interacitvity);
	}
}
