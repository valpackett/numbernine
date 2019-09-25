module upower.HistoryItem;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import upower.c.functions;
public  import upower.c.types;


/** */
public class HistoryItem : ObjectG
{
	/** the main Gtk struct */
	protected UpHistoryItem* upHistoryItem;

	/** Get the main Gtk struct */
	public UpHistoryItem* getHistoryItemStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return upHistoryItem;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)upHistoryItem;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (UpHistoryItem* upHistoryItem, bool ownedRef = false)
	{
		this.upHistoryItem = upHistoryItem;
		super(cast(GObject*)upHistoryItem, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return up_history_item_get_type();
	}

	/**
	 * Returns: a new UpHistoryItem object.
	 *
	 * Since: 0.9.0
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = up_history_item_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(UpHistoryItem*) p, true);
	}

	/**
	 * Gets the item state.
	 *
	 * Since: 0.9.0
	 */
	public UpDeviceState getState()
	{
		return up_history_item_get_state(upHistoryItem);
	}

	/**
	 * Gets the item time.
	 *
	 * Since: 0.9.0
	 */
	public uint getTime()
	{
		return up_history_item_get_time(upHistoryItem);
	}

	/**
	 * Gets the item value.
	 *
	 * Since: 0.9.0
	 */
	public double getValue()
	{
		return up_history_item_get_value(upHistoryItem);
	}

	/**
	 * Converts the history item to a string representation.
	 *
	 * Since: 0.9.1
	 */
	public bool setFromString(string text)
	{
		return up_history_item_set_from_string(upHistoryItem, Str.toStringz(text)) != 0;
	}

	/**
	 * Sets the item state.
	 *
	 * Params:
	 *     state = the new value
	 *
	 * Since: 0.9.0
	 */
	public void setState(UpDeviceState state)
	{
		up_history_item_set_state(upHistoryItem, state);
	}

	/**
	 * Sets the item time.
	 *
	 * Params:
	 *     time = the new value
	 *
	 * Since: 0.9.0
	 */
	public void setTime(uint time)
	{
		up_history_item_set_time(upHistoryItem, time);
	}

	/**
	 * Sets the item time to the present value.
	 *
	 * Since: 0.9.1
	 */
	public void setTimeToPresent()
	{
		up_history_item_set_time_to_present(upHistoryItem);
	}

	/**
	 * Sets the item value.
	 *
	 * Params:
	 *     value = the new value
	 *
	 * Since: 0.9.0
	 */
	public void setValue(double value)
	{
		up_history_item_set_value(upHistoryItem, value);
	}

	/**
	 * Converts the history item to a string representation.
	 *
	 * Since: 0.9.1
	 */
	public override string toString()
	{
		auto retStr = up_history_item_to_string(upHistoryItem);

		scope(exit) Str.freeString(retStr);
		return Str.toString(retStr);
	}
}
