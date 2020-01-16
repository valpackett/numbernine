module handy.PreferencesRow;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import gtk.ActionableIF;
private import gtk.ActionableT;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.ListBoxRow;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class PreferencesRow : ListBoxRow
{
	/** the main Gtk struct */
	protected HdyPreferencesRow* hdyPreferencesRow;

	/** Get the main Gtk struct */
	public HdyPreferencesRow* getPreferencesRowStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyPreferencesRow;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyPreferencesRow;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyPreferencesRow* hdyPreferencesRow, bool ownedRef = false)
	{
		this.hdyPreferencesRow = hdyPreferencesRow;
		super(cast(GtkListBoxRow*)hdyPreferencesRow, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_preferences_row_get_type();
	}

	/**
	 * Creates a new #HdyPreferencesRow.
	 *
	 * Returns: a new #HdyPreferencesRow
	 *
	 * Since: 0.0.10
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto __p = hdy_preferences_row_new();

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyPreferencesRow*) __p);
	}

	/**
	 * Gets the title of the preference represented by @self.
	 *
	 * Returns: the title of the preference represented
	 *     by @self, or %NULL.
	 *
	 * Since: 0.0.10
	 */
	public string getTitle()
	{
		return Str.toString(hdy_preferences_row_get_title(hdyPreferencesRow));
	}

	/**
	 * Gets whether an embedded underline in the text of the title indicates a
	 * mnemonic. See hdy_preferences_row_set_use_underline().
	 *
	 * Returns: %TRUE if an embedded underline in the title indicates the mnemonic
	 *     accelerator keys.
	 *
	 * Since: 0.0.10
	 */
	public bool getUseUnderline()
	{
		return hdy_preferences_row_get_use_underline(hdyPreferencesRow) != 0;
	}

	/**
	 * Sets the title of the preference represented by @self.
	 *
	 * Params:
	 *     title = the title, or %NULL.
	 *
	 * Since: 0.0.10
	 */
	public void setTitle(string title)
	{
		hdy_preferences_row_set_title(hdyPreferencesRow, Str.toStringz(title));
	}

	/**
	 * If true, an underline in the text of the title indicates the next character
	 * should be used for the mnemonic accelerator key.
	 *
	 * Params:
	 *     useUnderline = %TRUE if underlines in the text indicate mnemonics
	 *
	 * Since: 0.0.10
	 */
	public void setUseUnderline(bool useUnderline)
	{
		hdy_preferences_row_set_use_underline(hdyPreferencesRow, useUnderline);
	}
}
