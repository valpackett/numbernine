module upower.StatsItem;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import upower.c.functions;
public  import upower.c.types;


/** */
public class StatsItem : ObjectG
{
	/** the main Gtk struct */
	protected UpStatsItem* upStatsItem;

	/** Get the main Gtk struct */
	public UpStatsItem* getStatsItemStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return upStatsItem;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)upStatsItem;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (UpStatsItem* upStatsItem, bool ownedRef = false)
	{
		this.upStatsItem = upStatsItem;
		super(cast(GObject*)upStatsItem, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return up_stats_item_get_type();
	}

	/**
	 * Returns: a new UpStatsItem object.
	 *
	 * Since: 0.9.0
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = up_stats_item_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(UpStatsItem*) p, true);
	}

	/**
	 * Gets the item accuracy.
	 *
	 * Since: 0.9.0
	 */
	public double getAccuracy()
	{
		return up_stats_item_get_accuracy(upStatsItem);
	}

	/**
	 * Gets the item value.
	 *
	 * Since: 0.9.0
	 */
	public double getValue()
	{
		return up_stats_item_get_value(upStatsItem);
	}

	/**
	 * Sets the item accuracy.
	 *
	 * Since: 0.9.0
	 */
	public void setAccuracy(double accuracy)
	{
		up_stats_item_set_accuracy(upStatsItem, accuracy);
	}

	/**
	 * Sets the item value.
	 *
	 * Since: 0.9.0
	 */
	public void setValue(double value)
	{
		up_stats_item_set_value(upStatsItem, value);
	}
}
