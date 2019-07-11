module handy.HeaderGroup;

private import glib.ConstructionException;
private import glib.ListSG;
private import gobject.ObjectG;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.HeaderBar;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class HeaderGroup : ObjectG, BuildableIF
{
	/** the main Gtk struct */
	protected HdyHeaderGroup* hdyHeaderGroup;

	/** Get the main Gtk struct */
	public HdyHeaderGroup* getHeaderGroupStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyHeaderGroup;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyHeaderGroup;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyHeaderGroup* hdyHeaderGroup, bool ownedRef = false)
	{
		this.hdyHeaderGroup = hdyHeaderGroup;
		super(cast(GObject*)hdyHeaderGroup, ownedRef);
	}

	// add the Buildable capabilities
	mixin BuildableT!(HdyHeaderGroup);


	/** */
	public static GType getType()
	{
		return hdy_header_group_get_type();
	}

	/** */
	public this()
	{
		auto p = hdy_header_group_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyHeaderGroup*) p, true);
	}

	/**
	 * Adds a header bar to a #HdyHeaderGroup. The decoration layout of the
	 * widgets will be edited depending on their position in the composite header
	 * bar, the start widget displaying only the start of the user's decoration
	 * layout and the end widget displaying only its end while widgets in the middle
	 * won't display anything. A header bar can be set as having the focus to
	 * display all the decorations. See gtk_header_bar_set_decoration_layout().
	 *
	 * When the widget is destroyed or no longer referenced elsewhere, it will
	 * be removed from the header group.
	 *
	 * Params:
	 *     headerBar = the #GtkHeaderBar to add
	 */
	public void addHeaderBar(HeaderBar headerBar)
	{
		hdy_header_group_add_header_bar(hdyHeaderGroup, (headerBar is null) ? null : headerBar.getHeaderBarStruct());
	}

	/**
	 * Returns: The currently focused header bar
	 */
	public HeaderBar getFocus()
	{
		auto p = hdy_header_group_get_focus(hdyHeaderGroup);

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(HeaderBar)(cast(GtkHeaderBar*) p);
	}

	/**
	 * Returns the list of headerbars associated with @self.
	 *
	 * Returns: a #GSList of
	 *     headerbars. The list is owned by libhandy and should not be modified.
	 */
	public ListSG getHeaderBars()
	{
		auto p = hdy_header_group_get_header_bars(hdyHeaderGroup);

		if(p is null)
		{
			return null;
		}

		return new ListSG(cast(GSList*) p);
	}

	/**
	 * Removes a widget from a #HdyHeaderGroup
	 *
	 * Params:
	 *     headerBar = the #GtkHeaderBar to remove
	 */
	public void removeHeaderBar(HeaderBar headerBar)
	{
		hdy_header_group_remove_header_bar(hdyHeaderGroup, (headerBar is null) ? null : headerBar.getHeaderBarStruct());
	}

	/**
	 * Sets the the currently focused header bar. If @header_bar is %NULL, the
	 * decoration will be spread as if the header bars of the group were only one,
	 * otherwise @header_bar will be the only one to receive the decoration.
	 *
	 * Params:
	 *     headerBar = a #GtkHeaderBar of @self, or %NULL
	 */
	public void setFocus(HeaderBar headerBar)
	{
		hdy_header_group_set_focus(hdyHeaderGroup, (headerBar is null) ? null : headerBar.getHeaderBarStruct());
	}
}
