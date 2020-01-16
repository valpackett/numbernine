module handy.TitleBar;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import gtk.Bin;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class TitleBar : Bin
{
	/** the main Gtk struct */
	protected HdyTitleBar* hdyTitleBar;

	/** Get the main Gtk struct */
	public HdyTitleBar* getTitleBarStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyTitleBar;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyTitleBar;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyTitleBar* hdyTitleBar, bool ownedRef = false)
	{
		this.hdyTitleBar = hdyTitleBar;
		super(cast(GtkBin*)hdyTitleBar, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_title_bar_get_type();
	}

	/**
	 * Creates a new #HdyTitleBar.
	 *
	 * Returns: a new #HdyTitleBar
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto __p = hdy_title_bar_new();

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyTitleBar*) __p);
	}

	/**
	 * Returns wether whether @self is in selection mode.
	 *
	 * Returns: %TRUE if the title bar is in selection mode
	 */
	public bool getSelectionMode()
	{
		return hdy_title_bar_get_selection_mode(hdyTitleBar) != 0;
	}

	/**
	 * Sets whether @self is in selection mode.
	 *
	 * Params:
	 *     selectionMode = %TRUE to enable the selection mode
	 */
	public void setSelectionMode(bool selectionMode)
	{
		hdy_title_bar_set_selection_mode(hdyTitleBar, selectionMode);
	}
}
