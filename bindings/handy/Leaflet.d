module handy.Leaflet;

private import glib.ConstructionException;
private import glib.Str;
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
public class Leaflet : Container, OrientableIF
{
	/** the main Gtk struct */
	protected HdyLeaflet* hdyLeaflet;

	/** Get the main Gtk struct */
	public HdyLeaflet* getLeafletStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyLeaflet;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyLeaflet;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyLeaflet* hdyLeaflet, bool ownedRef = false)
	{
		this.hdyLeaflet = hdyLeaflet;
		super(cast(GtkContainer*)hdyLeaflet, ownedRef);
	}

	// add the Orientable capabilities
	mixin OrientableT!(HdyLeaflet);


	/** */
	public static GType getType()
	{
		return hdy_leaflet_get_type();
	}

	/** */
	public this()
	{
		auto __p = hdy_leaflet_new();

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyLeaflet*) __p);
	}

	/**
	 * Returns the amount of time (in milliseconds) that
	 * transitions between children in @self will take.
	 *
	 * Returns: the mode transition duration
	 */
	public uint getChildTransitionDuration()
	{
		return hdy_leaflet_get_child_transition_duration(hdyLeaflet);
	}

	/**
	 * Returns whether @self is currently in a transition from one page to
	 * another.
	 *
	 * Returns: %TRUE if the transition is currently running, %FALSE otherwise.
	 */
	public bool getChildTransitionRunning()
	{
		return hdy_leaflet_get_child_transition_running(hdyLeaflet) != 0;
	}

	/**
	 * Gets the type of animation that will be used
	 * for transitions between modes in @self.
	 *
	 * Returns: the current mode transition type of @self
	 */
	public HdyLeafletChildTransitionType getChildTransitionType()
	{
		return hdy_leaflet_get_child_transition_type(hdyLeaflet);
	}

	/**
	 * Gets the fold of @self.
	 *
	 * Returns: the fold of @self.
	 */
	public HdyFold getFold()
	{
		return hdy_leaflet_get_fold(hdyLeaflet);
	}

	/**
	 * Gets whether @self is homogeneous for the given fold and orientation.
	 * See hdy_leaflet_set_homogeneous().
	 *
	 * Params:
	 *     fold = the fold
	 *     orientation = the orientation
	 *
	 * Returns: whether @self is homogeneous for the given fold and orientation.
	 */
	public bool getHomogeneous(HdyFold fold, GtkOrientation orientation)
	{
		return hdy_leaflet_get_homogeneous(hdyLeaflet, fold, orientation) != 0;
	}

	/**
	 * Returns wether the #HdyLeaflet is set up to interpolate between
	 * the sizes of children on page switch.
	 *
	 * Returns: %TRUE if child sizes are interpolated
	 */
	public bool getInterpolateSize()
	{
		return hdy_leaflet_get_interpolate_size(hdyLeaflet) != 0;
	}

	/**
	 * Returns the amount of time (in milliseconds) that
	 * transitions between modes in @self will take.
	 *
	 * Returns: the mode transition duration
	 */
	public uint getModeTransitionDuration()
	{
		return hdy_leaflet_get_mode_transition_duration(hdyLeaflet);
	}

	/**
	 * Gets the type of animation that will be used
	 * for transitions between modes in @self.
	 *
	 * Returns: the current mode transition type of @self
	 */
	public HdyLeafletModeTransitionType getModeTransitionType()
	{
		return hdy_leaflet_get_mode_transition_type(hdyLeaflet);
	}

	/**
	 * Get the visible child widget.
	 *
	 * Returns: the visible child widget
	 */
	public Widget getVisibleChild()
	{
		auto __p = hdy_leaflet_get_visible_child(hdyLeaflet);

		if(__p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Widget)(cast(GtkWidget*) __p);
	}

	/** */
	public string getVisibleChildName()
	{
		return Str.toString(hdy_leaflet_get_visible_child_name(hdyLeaflet));
	}

	/**
	 * Sets the duration that transitions between children in @self
	 * will take.
	 *
	 * Params:
	 *     duration = the new duration, in milliseconds
	 */
	public void setChildTransitionDuration(uint duration)
	{
		hdy_leaflet_set_child_transition_duration(hdyLeaflet, duration);
	}

	/**
	 * Sets the type of animation that will be used for
	 * transitions between children in @self.
	 *
	 * The transition type can be changed without problems
	 * at runtime, so it is possible to change the animation
	 * based on the mode that is about to become current.
	 *
	 * Params:
	 *     transition = the new transition type
	 */
	public void setChildTransitionType(HdyLeafletChildTransitionType transition)
	{
		hdy_leaflet_set_child_transition_type(hdyLeaflet, transition);
	}

	/**
	 * Sets the #HdyLeaflet to be homogeneous or not for the given fold and orientation.
	 * If it is homogeneous, the #HdyLeaflet will request the same
	 * width or height for all its children depending on the orientation.
	 * If it isn't and it is folded, the leaflet may change width or height
	 * when a different child becomes visible.
	 *
	 * Params:
	 *     fold = the fold
	 *     orientation = the orientation
	 *     homogeneous = %TRUE to make @self homogeneous
	 */
	public void setHomogeneous(HdyFold fold, GtkOrientation orientation, bool homogeneous)
	{
		hdy_leaflet_set_homogeneous(hdyLeaflet, fold, orientation, homogeneous);
	}

	/**
	 * Sets whether or not @self will interpolate its size when
	 * changing the visible child. If the #HdyLeaflet:interpolate-size
	 * property is set to %TRUE, @stack will interpolate its size between
	 * the current one and the one it'll take after changing the
	 * visible child, according to the set transition duration.
	 *
	 * Params:
	 *     interpolateSize = the new value
	 */
	public void setInterpolateSize(bool interpolateSize)
	{
		hdy_leaflet_set_interpolate_size(hdyLeaflet, interpolateSize);
	}

	/**
	 * Sets the duration that transitions between modes in @self
	 * will take.
	 *
	 * Params:
	 *     duration = the new duration, in milliseconds
	 */
	public void setModeTransitionDuration(uint duration)
	{
		hdy_leaflet_set_mode_transition_duration(hdyLeaflet, duration);
	}

	/**
	 * Sets the type of animation that will be used for
	 * transitions between modes in @self.
	 *
	 * The transition type can be changed without problems
	 * at runtime, so it is possible to change the animation
	 * based on the mode that is about to become current.
	 *
	 * Params:
	 *     transition = the new transition type
	 */
	public void setModeTransitionType(HdyLeafletModeTransitionType transition)
	{
		hdy_leaflet_set_mode_transition_type(hdyLeaflet, transition);
	}

	/** */
	public void setVisibleChild(Widget visibleChild)
	{
		hdy_leaflet_set_visible_child(hdyLeaflet, (visibleChild is null) ? null : visibleChild.getWidgetStruct());
	}

	/** */
	public void setVisibleChildName(string name)
	{
		hdy_leaflet_set_visible_child_name(hdyLeaflet, Str.toStringz(name));
	}
}
