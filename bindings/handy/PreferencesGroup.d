module handy.PreferencesGroup;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import gtk.Box;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.OrientableIF;
private import gtk.OrientableT;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class PreferencesGroup : Box
{
	/** the main Gtk struct */
	protected HdyPreferencesGroup* hdyPreferencesGroup;

	/** Get the main Gtk struct */
	public HdyPreferencesGroup* getPreferencesGroupStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyPreferencesGroup;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyPreferencesGroup;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyPreferencesGroup* hdyPreferencesGroup, bool ownedRef = false)
	{
		this.hdyPreferencesGroup = hdyPreferencesGroup;
		super(cast(GtkBox*)hdyPreferencesGroup, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_preferences_group_get_type();
	}

	/**
	 * Creates a new #HdyPreferencesGroup.
	 *
	 * Returns: a new #HdyPreferencesGroup
	 *
	 * Since: 0.0.10
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto __p = hdy_preferences_group_new();

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyPreferencesGroup*) __p);
	}

	/**
	 * Returns: the description of @self.
	 *
	 * Since: 0.0.10
	 */
	public string getDescription()
	{
		return Str.toString(hdy_preferences_group_get_description(hdyPreferencesGroup));
	}

	/**
	 * Gets the title of @self.
	 *
	 * Returns: the title of @self.
	 *
	 * Since: 0.0.10
	 */
	public string getTitle()
	{
		return Str.toString(hdy_preferences_group_get_title(hdyPreferencesGroup));
	}

	/**
	 * Sets the description for @self.
	 *
	 * Params:
	 *     description = the description
	 *
	 * Since: 0.0.10
	 */
	public void setDescription(string description)
	{
		hdy_preferences_group_set_description(hdyPreferencesGroup, Str.toStringz(description));
	}

	/**
	 * Sets the title for @self.
	 *
	 * Params:
	 *     title = the title
	 *
	 * Since: 0.0.10
	 */
	public void setTitle(string title)
	{
		hdy_preferences_group_set_title(hdyPreferencesGroup, Str.toStringz(title));
	}
}
