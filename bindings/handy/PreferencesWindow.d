module handy.PreferencesWindow;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.Window;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class PreferencesWindow : Window
{
	/** the main Gtk struct */
	protected HdyPreferencesWindow* hdyPreferencesWindow;

	/** Get the main Gtk struct */
	public HdyPreferencesWindow* getPreferencesWindowStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyPreferencesWindow;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyPreferencesWindow;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyPreferencesWindow* hdyPreferencesWindow, bool ownedRef = false)
	{
		this.hdyPreferencesWindow = hdyPreferencesWindow;
		super(cast(GtkWindow*)hdyPreferencesWindow, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_preferences_window_get_type();
	}

	/**
	 * Creates a new #HdyPreferencesWindow.
	 *
	 * Returns: a new #HdyPreferencesWindow
	 *
	 * Since: 0.0.10
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = hdy_preferences_window_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyPreferencesWindow*) p);
	}
}
