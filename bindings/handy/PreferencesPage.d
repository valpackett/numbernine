module handy.PreferencesPage;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.ScrolledWindow;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class PreferencesPage : ScrolledWindow
{
	/** the main Gtk struct */
	protected HdyPreferencesPage* hdyPreferencesPage;

	/** Get the main Gtk struct */
	public HdyPreferencesPage* getPreferencesPageStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyPreferencesPage;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyPreferencesPage;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyPreferencesPage* hdyPreferencesPage, bool ownedRef = false)
	{
		this.hdyPreferencesPage = hdyPreferencesPage;
		super(cast(GtkScrolledWindow*)hdyPreferencesPage, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_preferences_page_get_type();
	}

	/**
	 * Creates a new #HdyPreferencesPage.
	 *
	 * Returns: a new #HdyPreferencesPage
	 *
	 * Since: 0.0.10
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = hdy_preferences_page_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyPreferencesPage*) p);
	}

	/**
	 * Gets the icon name for @self, or %NULL.
	 *
	 * Returns: the icon name for @self, or %NULL.
	 *
	 * Since: 0.0.10
	 */
	public string getIconName()
	{
		return Str.toString(hdy_preferences_page_get_icon_name(hdyPreferencesPage));
	}

	/**
	 * Gets the title of @self, or %NULL.
	 *
	 * Returns: the title of the @self, or %NULL.
	 *
	 * Since: 0.0.10
	 */
	public string getTitle()
	{
		return Str.toString(hdy_preferences_page_get_title(hdyPreferencesPage));
	}

	/**
	 * Sets the icon name for @self.
	 *
	 * Params:
	 *     iconName = the icon name, or %NULL
	 *
	 * Since: 0.0.10
	 */
	public void setIconName(string iconName)
	{
		hdy_preferences_page_set_icon_name(hdyPreferencesPage, Str.toStringz(iconName));
	}

	/**
	 * Sets the title of @self.
	 *
	 * Params:
	 *     title = the title of the page, or %NULL
	 *
	 * Since: 0.0.10
	 */
	public void setTitle(string title)
	{
		hdy_preferences_page_set_title(hdyPreferencesPage, Str.toStringz(title));
	}
}
