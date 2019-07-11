module handy.Column;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import gtk.Bin;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class Column : Bin
{
	/** the main Gtk struct */
	protected HdyColumn* hdyColumn;

	/** Get the main Gtk struct */
	public HdyColumn* getColumnStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyColumn;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyColumn;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyColumn* hdyColumn, bool ownedRef = false)
	{
		this.hdyColumn = hdyColumn;
		super(cast(GtkBin*)hdyColumn, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_column_get_type();
	}

	/**
	 * Creates a new #HdyColumn.
	 *
	 * Returns: a new #HdyColumn
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = hdy_column_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyColumn*) p);
	}

	/**
	 * Gets the width up to which the child will be allocated all the available
	 * width and starting from which it will be allocated a portion of the available
	 * width. In bith cases the allocated width won't exceed the declared maximum.
	 *
	 * Returns: the width up to which the child will be allocated all the available
	 *     width.
	 */
	public int getLinearGrowthWidth()
	{
		return hdy_column_get_linear_growth_width(hdyColumn);
	}

	/**
	 * Gets the maximum width to allocate to the contained child.
	 *
	 * Returns: the maximum width to allocate to the contained child.
	 */
	public int getMaximumWidth()
	{
		return hdy_column_get_maximum_width(hdyColumn);
	}

	/**
	 * Sets the width up to which the child will be allocated all the available
	 * width and starting from which it will be allocated a portion of the available
	 * width. In bith cases the allocated width won't exceed the declared maximum.
	 *
	 * Params:
	 *     linearGrowthWidth = the linear growth width
	 */
	public void setLinearGrowthWidth(int linearGrowthWidth)
	{
		hdy_column_set_linear_growth_width(hdyColumn, linearGrowthWidth);
	}

	/**
	 * Sets the maximum width to allocate to the contained child.
	 *
	 * Params:
	 *     maximumWidth = the maximum width
	 */
	public void setMaximumWidth(int maximumWidth)
	{
		hdy_column_set_maximum_width(hdyColumn, maximumWidth);
	}
}
