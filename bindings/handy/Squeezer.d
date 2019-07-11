module handy.Squeezer;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.Container;
private import gtk.OrientableIF;
private import gtk.OrientableT;
private import gtk.Widget;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class Squeezer : Container, OrientableIF
{
	/** the main Gtk struct */
	protected HdySqueezer* hdySqueezer;

	/** Get the main Gtk struct */
	public HdySqueezer* getSqueezerStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdySqueezer;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdySqueezer;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdySqueezer* hdySqueezer, bool ownedRef = false)
	{
		this.hdySqueezer = hdySqueezer;
		super(cast(GtkContainer*)hdySqueezer, ownedRef);
	}

	// add the Orientable capabilities
	mixin OrientableT!(HdySqueezer);


	/** */
	public static GType getType()
	{
		return hdy_squeezer_get_type();
	}

	/**
	 * Creates a new #HdySqueezer container.
	 *
	 * Returns: a new #HdySqueezer
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = hdy_squeezer_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdySqueezer*) p);
	}

	/**
	 * Gets whether @child is enabled.
	 *
	 * See hdy_squeezer_set_child_enabled().
	 *
	 * Params:
	 *     child = a child of @self
	 *
	 * Returns: %TRUE if @child is enabled, %FALSE otherwise.
	 */
	public bool getChildEnabled(Widget child)
	{
		return hdy_squeezer_get_child_enabled(hdySqueezer, (child is null) ? null : child.getWidgetStruct()) != 0;
	}

	/**
	 * Gets whether @self is homogeneous.
	 *
	 * See hdy_squeezer_set_homogeneous().
	 *
	 * Returns: %TRUE if @self is homogeneous, %FALSE is not
	 *
	 * Since: 0.0.10
	 */
	public bool getHomogeneous()
	{
		return hdy_squeezer_get_homogeneous(hdySqueezer) != 0;
	}

	/**
	 * Gets wether @self should interpolate its size on visible child change.
	 *
	 * See hdy_squeezer_set_interpolate_size().
	 *
	 * Returns: %TRUE if @self interpolates its size on visible child change, %FALSE if not
	 *
	 * Since: 0.0.10
	 */
	public bool getInterpolateSize()
	{
		return hdy_squeezer_get_interpolate_size(hdySqueezer) != 0;
	}

	/**
	 * Gets the amount of time (in milliseconds) that transitions between children
	 * in @self will take.
	 *
	 * Returns: the transition duration
	 */
	public uint getTransitionDuration()
	{
		return hdy_squeezer_get_transition_duration(hdySqueezer);
	}

	/**
	 * Gets whether @self is currently in a transition from one child to another.
	 *
	 * Returns: %TRUE if the transition is currently running, %FALSE otherwise.
	 */
	public bool getTransitionRunning()
	{
		return hdy_squeezer_get_transition_running(hdySqueezer) != 0;
	}

	/**
	 * Gets the type of animation that will be used for transitions between children
	 * in @self.
	 *
	 * Returns: the current transition type of @self
	 */
	public HdySqueezerTransitionType getTransitionType()
	{
		return hdy_squeezer_get_transition_type(hdySqueezer);
	}

	/**
	 * Gets the currently visible child of @self, or %NULL if there are no visible
	 * children.
	 *
	 * Returns: the visible child of the #HdySqueezer
	 */
	public Widget getVisibleChild()
	{
		auto p = hdy_squeezer_get_visible_child(hdySqueezer);

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Widget)(cast(GtkWidget*) p);
	}

	/**
	 * Make @self enable or disable @child. If a child is disabled, it will be
	 * ignored when looking for the child fitting the available size best. This
	 * allows to programmatically and prematurely hide a child of @self even if it
	 * fits in the available space.
	 *
	 * This can be used e.g. to ensure a certain child is hidden below a certain
	 * window width, or any other constraint you find suitable.
	 *
	 * Params:
	 *     child = a child of @self
	 *     enabled = %TRUE to enable the child, %FALSE to disable it
	 */
	public void setChildEnabled(Widget child, bool enabled)
	{
		hdy_squeezer_set_child_enabled(hdySqueezer, (child is null) ? null : child.getWidgetStruct(), enabled);
	}

	/**
	 * Sets @self to be homogeneous or not. If it is homogeneous, @self will request
	 * the same size for all its children for its opposite orientation, e.g. if
	 * @self is oriented horizontally and is homogeneous, it will request the same
	 * height for all its children. If it isn't, @self may change size when a
	 * different child becomes visible.
	 *
	 * Params:
	 *     homogeneous = %TRUE to make @self homogeneous
	 *
	 * Since: 0.0.10
	 */
	public void setHomogeneous(bool homogeneous)
	{
		hdy_squeezer_set_homogeneous(hdySqueezer, homogeneous);
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
		hdy_squeezer_set_interpolate_size(hdySqueezer, interpolateSize);
	}

	/**
	 * Sets the duration that transitions between children in @self will take.
	 *
	 * Params:
	 *     duration = the new duration, in milliseconds
	 */
	public void setTransitionDuration(uint duration)
	{
		hdy_squeezer_set_transition_duration(hdySqueezer, duration);
	}

	/**
	 * Sets the type of animation that will be used for transitions between children
	 * in @self. Available types include various kinds of fades and slides.
	 *
	 * The transition type can be changed without problems at runtime, so it is
	 * possible to change the animation based on the child that is about to become
	 * current.
	 *
	 * Params:
	 *     transition = the new transition type
	 */
	public void setTransitionType(HdySqueezerTransitionType transition)
	{
		hdy_squeezer_set_transition_type(hdySqueezer, transition);
	}
}
