module handy.ExpanderRow;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import handy.ActionRow;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class ExpanderRow : ActionRow
{
	/** the main Gtk struct */
	protected HdyExpanderRow* hdyExpanderRow;

	/** Get the main Gtk struct */
	public HdyExpanderRow* getExpanderRowStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyExpanderRow;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyExpanderRow;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyExpanderRow* hdyExpanderRow, bool ownedRef = false)
	{
		this.hdyExpanderRow = hdyExpanderRow;
		super(cast(HdyActionRow*)hdyExpanderRow, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_expander_row_get_type();
	}

	/**
	 * Creates a new #HdyExpanderRow.
	 *
	 * Returns: a new #HdyExpanderRow
	 *
	 * Since: 0.0.6
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = hdy_expander_row_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyExpanderRow*) p);
	}

	/**
	 * Gets whether the expansion of @self is enabled.
	 *
	 * Returns: whether the expansion of @self is enabled.
	 *
	 * Since: 0.0.6
	 */
	public bool getEnableExpansion()
	{
		return hdy_expander_row_get_enable_expansion(hdyExpanderRow) != 0;
	}

	/** */
	public bool getExpanded()
	{
		return hdy_expander_row_get_expanded(hdyExpanderRow) != 0;
	}

	/**
	 * Gets whether the switch enabling the expansion of @self is visible.
	 *
	 * Returns: whether the switch enabling the expansion of @self is visible.
	 *
	 * Since: 0.0.6
	 */
	public bool getShowEnableSwitch()
	{
		return hdy_expander_row_get_show_enable_switch(hdyExpanderRow) != 0;
	}

	/**
	 * Sets whether the expansion of @self is enabled.
	 *
	 * Params:
	 *     enableExpansion = %TRUE to enable the expansion
	 *
	 * Since: 0.0.6
	 */
	public void setEnableExpansion(bool enableExpansion)
	{
		hdy_expander_row_set_enable_expansion(hdyExpanderRow, enableExpansion);
	}

	/** */
	public void setExpanded(bool expanded)
	{
		hdy_expander_row_set_expanded(hdyExpanderRow, expanded);
	}

	/**
	 * Sets whether the switch enabling the expansion of @self is visible.
	 *
	 * Params:
	 *     showEnableSwitch = %TRUE to show the switch enabling the expansion
	 *
	 * Since: 0.0.6
	 */
	public void setShowEnableSwitch(bool showEnableSwitch)
	{
		hdy_expander_row_set_show_enable_switch(hdyExpanderRow, showEnableSwitch);
	}
}
