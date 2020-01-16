module handy.ViewSwitcher;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import gtk.Box;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.OrientableIF;
private import gtk.OrientableT;
private import gtk.Stack;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class ViewSwitcher : Box
{
	/** the main Gtk struct */
	protected HdyViewSwitcher* hdyViewSwitcher;

	/** Get the main Gtk struct */
	public HdyViewSwitcher* getViewSwitcherStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyViewSwitcher;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyViewSwitcher;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyViewSwitcher* hdyViewSwitcher, bool ownedRef = false)
	{
		this.hdyViewSwitcher = hdyViewSwitcher;
		super(cast(GtkBox*)hdyViewSwitcher, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_view_switcher_get_type();
	}

	/**
	 * Creates a new #HdyViewSwitcher widget.
	 *
	 * Returns: a new #HdyViewSwitcher
	 *
	 * Since: 0.0.10
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto __p = hdy_view_switcher_new();

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyViewSwitcher*) __p);
	}

	/**
	 * Get the icon size of the images used in the #HdyViewSwitcher.
	 *
	 * See: hdy_view_switcher_set_icon_size()
	 *
	 * Returns: the icon size of the images
	 *
	 * Since: 0.0.10
	 */
	public GtkIconSize getIconSize()
	{
		return hdy_view_switcher_get_icon_size(hdyViewSwitcher);
	}

	/**
	 * Get the ellipsizing position of the narrow mode label. See
	 * hdy_view_switcher_set_narrow_ellipsize().
	 *
	 * Returns: #PangoEllipsizeMode
	 *
	 * Since: 0.0.10
	 */
	public PangoEllipsizeMode getNarrowEllipsize()
	{
		return hdy_view_switcher_get_narrow_ellipsize(hdyViewSwitcher);
	}

	/**
	 * Gets the policy of @self.
	 *
	 * Returns: the policy of @self
	 *
	 * Since: 0.0.10
	 */
	public HdyViewSwitcherPolicy getPolicy()
	{
		return hdy_view_switcher_get_policy(hdyViewSwitcher);
	}

	/**
	 * Get the #GtkStack being controlled by the #HdyViewSwitcher.
	 *
	 * See: hdy_view_switcher_set_stack()
	 *
	 * Returns: the #GtkStack, or %NULL if none has been set
	 *
	 * Since: 0.0.10
	 */
	public Stack getStack()
	{
		auto __p = hdy_view_switcher_get_stack(hdyViewSwitcher);

		if(__p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Stack)(cast(GtkStack*) __p);
	}

	/**
	 * Change the icon size hint for the icons in a #HdyViewSwitcher.
	 *
	 * Params:
	 *     iconSize = the new icon size
	 *
	 * Since: 0.0.10
	 */
	public void setIconSize(GtkIconSize iconSize)
	{
		hdy_view_switcher_set_icon_size(hdyViewSwitcher, iconSize);
	}

	/**
	 * Set the mode used to ellipsize the text in narrow mode if there is not
	 * enough space to render the entire string.
	 *
	 * Params:
	 *     mode = a #PangoEllipsizeMode
	 *
	 * Since: 0.0.10
	 */
	public void setNarrowEllipsize(PangoEllipsizeMode mode)
	{
		hdy_view_switcher_set_narrow_ellipsize(hdyViewSwitcher, mode);
	}

	/**
	 * Sets the policy of @self.
	 *
	 * Params:
	 *     policy = the new policy
	 *
	 * Since: 0.0.10
	 */
	public void setPolicy(HdyViewSwitcherPolicy policy)
	{
		hdy_view_switcher_set_policy(hdyViewSwitcher, policy);
	}

	/**
	 * Sets the #GtkStack to control.
	 *
	 * Params:
	 *     stack = a #GtkStack
	 *
	 * Since: 0.0.10
	 */
	public void setStack(Stack stack)
	{
		hdy_view_switcher_set_stack(hdyViewSwitcher, (stack is null) ? null : stack.getStackStruct());
	}
}
