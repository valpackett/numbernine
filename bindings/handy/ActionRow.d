module handy.ActionRow;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import gtk.Widget;
private import handy.PreferencesRow;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class ActionRow : PreferencesRow
{
	/** the main Gtk struct */
	protected HdyActionRow* hdyActionRow;

	/** Get the main Gtk struct */
	public HdyActionRow* getActionRowStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyActionRow;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyActionRow;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyActionRow* hdyActionRow, bool ownedRef = false)
	{
		this.hdyActionRow = hdyActionRow;
		super(cast(HdyPreferencesRow*)hdyActionRow, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_action_row_get_type();
	}

	/**
	 * Creates a new #HdyActionRow.
	 *
	 * Returns: a new #HdyActionRow
	 *
	 * Since: 0.0.6
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto __p = hdy_action_row_new();

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyActionRow*) __p);
	}

	/** */
	public override void activate()
	{
		hdy_action_row_activate(hdyActionRow);
	}

	/**
	 * Adds an action widget to @self.
	 *
	 * Params:
	 *     widget = the action widget
	 *
	 * Since: 0.0.6
	 */
	public void addAction(Widget widget)
	{
		hdy_action_row_add_action(hdyActionRow, (widget is null) ? null : widget.getWidgetStruct());
	}

	/**
	 * Adds a prefix widget to @self.
	 *
	 * Params:
	 *     widget = the prefix widget
	 *
	 * Since: 0.0.6
	 */
	public void addPrefix(Widget widget)
	{
		hdy_action_row_add_prefix(hdyActionRow, (widget is null) ? null : widget.getWidgetStruct());
	}

	/**
	 * Gets the widget activated when @self is activated.
	 *
	 * Returns: the widget activated when @self is
	 *     activated, or %NULL if none has been set.
	 *
	 * Since: 0.0.7
	 */
	public Widget getActivatableWidget()
	{
		auto __p = hdy_action_row_get_activatable_widget(hdyActionRow);

		if(__p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Widget)(cast(GtkWidget*) __p);
	}

	/**
	 * Gets the icon name for @self.
	 *
	 * Returns: the icon name for @self.
	 *
	 * Since: 0.0.6
	 */
	public string getIconName()
	{
		return Str.toString(hdy_action_row_get_icon_name(hdyActionRow));
	}

	/**
	 * Gets the subtitle for @self.
	 *
	 * Returns: the subtitle for @self.
	 *
	 * Since: 0.0.6
	 */
	public string getSubtitle()
	{
		return Str.toString(hdy_action_row_get_subtitle(hdyActionRow));
	}

	/**
	 * Gets the title for @self.
	 *
	 * Returns: the title for @self.
	 *
	 * Since: 0.0.6
	 */
	public override string getTitle()
	{
		return Str.toString(hdy_action_row_get_title(hdyActionRow));
	}

	/**
	 * Gets whether an embedded underline in the text of the title and subtitle
	 * labels indicates a mnemonic. See hdy_action_row_set_use_underline().
	 *
	 * Returns: %TRUE if an embedded underline in the title and subtitle labels
	 *     indicates the mnemonic accelerator keys.
	 *
	 * Since: 0.0.6
	 */
	public override bool getUseUnderline()
	{
		return hdy_action_row_get_use_underline(hdyActionRow) != 0;
	}

	/**
	 * Sets the widget to activate when @self is activated, either by clicking
	 * on it, by calling hdy_action_row_activate(), or via mnemonics in the title or
	 * the subtitle. See the “use_underline” property to enable mnemonics.
	 *
	 * The target widget will be activated by emitting the
	 * GtkWidget::mnemonic-activate signal on it.
	 *
	 * Params:
	 *     widget = the target #GtkWidget, or %NULL to unset
	 *
	 * Since: 0.0.7
	 */
	public void setActivatableWidget(Widget widget)
	{
		hdy_action_row_set_activatable_widget(hdyActionRow, (widget is null) ? null : widget.getWidgetStruct());
	}

	/**
	 * Sets the icon name for @self.
	 *
	 * Params:
	 *     iconName = the icon name
	 *
	 * Since: 0.0.6
	 */
	public void setIconName(string iconName)
	{
		hdy_action_row_set_icon_name(hdyActionRow, Str.toStringz(iconName));
	}

	/**
	 * Sets the subtitle for @self.
	 *
	 * Params:
	 *     subtitle = the subtitle
	 *
	 * Since: 0.0.6
	 */
	public void setSubtitle(string subtitle)
	{
		hdy_action_row_set_subtitle(hdyActionRow, Str.toStringz(subtitle));
	}

	/**
	 * Sets the title for @self.
	 *
	 * Params:
	 *     title = the title
	 *
	 * Since: 0.0.6
	 */
	public override void setTitle(string title)
	{
		hdy_action_row_set_title(hdyActionRow, Str.toStringz(title));
	}

	/**
	 * If true, an underline in the text of the title and subtitle labels indicates
	 * the next character should be used for the mnemonic accelerator key.
	 *
	 * Params:
	 *     useUnderline = %TRUE if underlines in the text indicate mnemonics
	 *
	 * Since: 0.0.6
	 */
	public override void setUseUnderline(bool useUnderline)
	{
		hdy_action_row_set_use_underline(hdyActionRow, useUnderline);
	}
}
