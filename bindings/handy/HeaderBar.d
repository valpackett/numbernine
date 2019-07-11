module handy.HeaderBar;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.Container;
private import gtk.Widget;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class HeaderBar : Container
{
	/** the main Gtk struct */
	protected HdyHeaderBar* hdyHeaderBar;

	/** Get the main Gtk struct */
	public HdyHeaderBar* getHeaderBarStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyHeaderBar;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyHeaderBar;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyHeaderBar* hdyHeaderBar, bool ownedRef = false)
	{
		this.hdyHeaderBar = hdyHeaderBar;
		super(cast(GtkContainer*)hdyHeaderBar, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_header_bar_get_type();
	}

	/**
	 * Creates a new #HdyHeaderBar widget.
	 *
	 * Returns: a new #HdyHeaderBar
	 *
	 * Since: 0.0.10
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = hdy_header_bar_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyHeaderBar*) p);
	}

	/**
	 * Gets the policy @self follows to horizontally align its center widget.
	 *
	 * Returns: the centering policy
	 *
	 * Since: 0.0.10
	 */
	public HdyCenteringPolicy getCenteringPolicy()
	{
		return hdy_header_bar_get_centering_policy(hdyHeaderBar);
	}

	/**
	 * Retrieves the custom title widget of the header. See
	 * hdy_header_bar_set_custom_title().
	 *
	 * Returns: the custom title widget
	 *     of the header, or %NULL if none has been set explicitly.
	 *
	 * Since: 0.0.10
	 */
	public Widget getCustomTitle()
	{
		auto p = hdy_header_bar_get_custom_title(hdyHeaderBar);

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Widget)(cast(GtkWidget*) p);
	}

	/**
	 * Gets the decoration layout set with
	 * hdy_header_bar_set_decoration_layout().
	 *
	 * Returns: the decoration layout
	 *
	 * Since: 0.0.10
	 */
	public string getDecorationLayout()
	{
		return Str.toString(hdy_header_bar_get_decoration_layout(hdyHeaderBar));
	}

	/**
	 * Retrieves whether the header bar reserves space for
	 * a subtitle, regardless if one is currently set or not.
	 *
	 * Returns: %TRUE if the header bar reserves space
	 *     for a subtitle
	 *
	 * Since: 0.0.10
	 */
	public bool getHasSubtitle()
	{
		return hdy_header_bar_get_has_subtitle(hdyHeaderBar) != 0;
	}

	/**
	 * Gets wether @self should interpolate its size on visible child change.
	 *
	 * See hdy_header_bar_set_interpolate_size().
	 *
	 * Returns: %TRUE if @self interpolates its size on visible child change, %FALSE if not
	 *
	 * Since: 0.0.10
	 */
	public bool getInterpolateSize()
	{
		return hdy_header_bar_get_interpolate_size(hdyHeaderBar) != 0;
	}

	/**
	 * Returns whether this header bar shows the standard window
	 * decorations.
	 *
	 * Returns: %TRUE if the decorations are shown
	 *
	 * Since: 0.0.10
	 */
	public bool getShowCloseButton()
	{
		return hdy_header_bar_get_show_close_button(hdyHeaderBar) != 0;
	}

	/**
	 * Retrieves the subtitle of the header. See hdy_header_bar_set_subtitle().
	 *
	 * Returns: the subtitle of the header, or %NULL if none has
	 *     been set explicitly. The returned string is owned by the widget
	 *     and must not be modified or freed.
	 *
	 * Since: 0.0.10
	 */
	public string getSubtitle()
	{
		return Str.toString(hdy_header_bar_get_subtitle(hdyHeaderBar));
	}

	/**
	 * Retrieves the title of the header. See hdy_header_bar_set_title().
	 *
	 * Returns: the title of the header, or %NULL if none has
	 *     been set explicitly. The returned string is owned by the widget
	 *     and must not be modified or freed.
	 *
	 * Since: 0.0.10
	 */
	public string getTitle()
	{
		return Str.toString(hdy_header_bar_get_title(hdyHeaderBar));
	}

	/**
	 * Returns the amount of time (in milliseconds) that
	 * transitions between pages in @self will take.
	 *
	 * Returns: the transition duration
	 *
	 * Since: 0.0.10
	 */
	public uint getTransitionDuration()
	{
		return hdy_header_bar_get_transition_duration(hdyHeaderBar);
	}

	/**
	 * Returns whether the @self is currently in a transition from one page to
	 * another.
	 *
	 * Returns: %TRUE if the transition is currently running, %FALSE otherwise.
	 *
	 * Since: 0.0.10
	 */
	public bool getTransitionRunning()
	{
		return hdy_header_bar_get_transition_running(hdyHeaderBar) != 0;
	}

	/**
	 * Adds @child to @self:, packed with reference to the
	 * end of the @self:.
	 *
	 * Params:
	 *     child = the #GtkWidget to be added to @self:
	 *
	 * Since: 0.0.10
	 */
	public void packEnd(Widget child)
	{
		hdy_header_bar_pack_end(hdyHeaderBar, (child is null) ? null : child.getWidgetStruct());
	}

	/**
	 * Adds @child to @self:, packed with reference to the
	 * start of the @self:.
	 *
	 * Params:
	 *     child = the #GtkWidget to be added to @self:
	 *
	 * Since: 0.0.10
	 */
	public void packStart(Widget child)
	{
		hdy_header_bar_pack_start(hdyHeaderBar, (child is null) ? null : child.getWidgetStruct());
	}

	/**
	 * Sets the policy @self must follow to horizontally align its center widget.
	 *
	 * Params:
	 *     centeringPolicy = the centering policy
	 *
	 * Since: 0.0.10
	 */
	public void setCenteringPolicy(HdyCenteringPolicy centeringPolicy)
	{
		hdy_header_bar_set_centering_policy(hdyHeaderBar, centeringPolicy);
	}

	/**
	 * Sets a custom title for the #HdyHeaderBar.
	 *
	 * The title should help a user identify the current view. This
	 * supersedes any title set by hdy_header_bar_set_title() or
	 * hdy_header_bar_set_subtitle(). To achieve the same style as
	 * the builtin title and subtitle, use the “title” and “subtitle”
	 * style classes.
	 *
	 * You should set the custom title to %NULL, for the header title
	 * label to be visible again.
	 *
	 * Params:
	 *     titleWidget = a custom widget to use for a title
	 *
	 * Since: 0.0.10
	 */
	public void setCustomTitle(Widget titleWidget)
	{
		hdy_header_bar_set_custom_title(hdyHeaderBar, (titleWidget is null) ? null : titleWidget.getWidgetStruct());
	}

	/**
	 * Sets the decoration layout for this header bar, overriding
	 * the #GtkSettings:gtk-decoration-layout setting.
	 *
	 * There can be valid reasons for overriding the setting, such
	 * as a header bar design that does not allow for buttons to take
	 * room on the right, or only offers room for a single close button.
	 * Split header bars are another example for overriding the
	 * setting.
	 *
	 * The format of the string is button names, separated by commas.
	 * A colon separates the buttons that should appear on the left
	 * from those on the right. Recognized button names are minimize,
	 * maximize, close, icon (the window icon) and menu (a menu button
	 * for the fallback app menu).
	 *
	 * For example, “menu:minimize,maximize,close” specifies a menu
	 * on the left, and minimize, maximize and close buttons on the right.
	 *
	 * Params:
	 *     layout = a decoration layout, or %NULL to
	 *         unset the layout
	 *
	 * Since: 0.0.10
	 */
	public void setDecorationLayout(string layout)
	{
		hdy_header_bar_set_decoration_layout(hdyHeaderBar, Str.toStringz(layout));
	}

	/**
	 * Sets whether the header bar should reserve space
	 * for a subtitle, even if none is currently set.
	 *
	 * Params:
	 *     setting = %TRUE to reserve space for a subtitle
	 *
	 * Since: 0.0.10
	 */
	public void setHasSubtitle(bool setting)
	{
		hdy_header_bar_set_has_subtitle(hdyHeaderBar, setting);
	}

	/**
	 * Sets whether or not @self will interpolate the size of its opposing
	 * orientation when changing the visible child. If %TRUE, @self will interpolate
	 * its size between the one of the previous visible child and the one of the new
	 * visible child, according to the set transition duration and the orientation,
	 * e.g. if @self is horizontal, it will interpolate the its height.
	 *
	 * Params:
	 *     interpolateSize = %TRUE to interpolate the size
	 *
	 * Since: 0.0.10
	 */
	public void setInterpolateSize(bool interpolateSize)
	{
		hdy_header_bar_set_interpolate_size(hdyHeaderBar, interpolateSize);
	}

	/**
	 * Sets whether this header bar shows the standard window decorations,
	 * including close, maximize, and minimize.
	 *
	 * Params:
	 *     setting = %TRUE to show standard window decorations
	 *
	 * Since: 0.0.10
	 */
	public void setShowCloseButton(bool setting)
	{
		hdy_header_bar_set_show_close_button(hdyHeaderBar, setting);
	}

	/**
	 * Sets the subtitle of the #HdyHeaderBar. The title should give a user
	 * an additional detail to help him identify the current view.
	 *
	 * Note that HdyHeaderBar by default reserves room for the subtitle,
	 * even if none is currently set. If this is not desired, set the
	 * #HdyHeaderBar:has-subtitle property to %FALSE.
	 *
	 * Params:
	 *     subtitle = a subtitle, or %NULL
	 *
	 * Since: 0.0.10
	 */
	public void setSubtitle(string subtitle)
	{
		hdy_header_bar_set_subtitle(hdyHeaderBar, Str.toStringz(subtitle));
	}

	/**
	 * Sets the title of the #HdyHeaderBar. The title should help a user
	 * identify the current view. A good title should not include the
	 * application name.
	 *
	 * Params:
	 *     title = a title, or %NULL
	 *
	 * Since: 0.0.10
	 */
	public void setTitle(string title)
	{
		hdy_header_bar_set_title(hdyHeaderBar, Str.toStringz(title));
	}

	/**
	 * Sets the duration that transitions between pages in @self
	 * will take.
	 *
	 * Params:
	 *     duration = the new duration, in milliseconds
	 *
	 * Since: 0.0.10
	 */
	public void setTransitionDuration(uint duration)
	{
		hdy_header_bar_set_transition_duration(hdyHeaderBar, duration);
	}
}
