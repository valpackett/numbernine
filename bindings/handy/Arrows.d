module handy.Arrows;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.DrawingArea;
private import gtk.Widget;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class Arrows : DrawingArea
{
	/** the main Gtk struct */
	protected HdyArrows* hdyArrows;

	/** Get the main Gtk struct */
	public HdyArrows* getArrowsStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyArrows;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyArrows;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyArrows* hdyArrows, bool ownedRef = false)
	{
		this.hdyArrows = hdyArrows;
		super(cast(GtkDrawingArea*)hdyArrows, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_arrows_get_type();
	}

	/**
	 * Create a new #HdyArrows widget.
	 *
	 * Returns: the newly created #HdyArrows widget
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = hdy_arrows_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyArrows*) p);
	}

	/**
	 * Render the arrows animation.
	 */
	public void animate()
	{
		hdy_arrows_animate(hdyArrows);
	}

	/**
	 * Get the number of arrows displayed in the widget.
	 *
	 * Returns: the current number of arrows
	 */
	public uint getCount()
	{
		return hdy_arrows_get_count(hdyArrows);
	}

	/**
	 * Get the direction the arrows point to
	 *
	 * Returns: the arrows direction
	 */
	public override HdyArrowsDirection getDirection()
	{
		return hdy_arrows_get_direction(hdyArrows);
	}

	/**
	 * Get the duration of the arrows animation.
	 *
	 * Returns: the duration of the animation in ms
	 */
	public uint getDuration()
	{
		return hdy_arrows_get_duration(hdyArrows);
	}

	/**
	 * Set the number of arrows to display.
	 *
	 * Params:
	 *     count = the number of arrows to display
	 */
	public void setCount(uint count)
	{
		hdy_arrows_set_count(hdyArrows, count);
	}

	/**
	 * Set the direction the arrows should point to.
	 *
	 * Params:
	 *     direction = the arrows direction
	 */
	public void setDirection(HdyArrowsDirection direction)
	{
		hdy_arrows_set_direction(hdyArrows, direction);
	}

	/**
	 * Set the duration of the arrow animation.
	 *
	 * Params:
	 *     duration = the duration of the animation in ms
	 */
	public void setDuration(uint duration)
	{
		hdy_arrows_set_duration(hdyArrows, duration);
	}
}
