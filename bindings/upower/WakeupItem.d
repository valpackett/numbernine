module upower.WakeupItem;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import upower.c.functions;
public  import upower.c.types;


/** */
public class WakeupItem : ObjectG
{
	/** the main Gtk struct */
	protected UpWakeupItem* upWakeupItem;

	/** Get the main Gtk struct */
	public UpWakeupItem* getWakeupItemStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return upWakeupItem;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)upWakeupItem;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (UpWakeupItem* upWakeupItem, bool ownedRef = false)
	{
		this.upWakeupItem = upWakeupItem;
		super(cast(GObject*)upWakeupItem, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return up_wakeup_item_get_type();
	}

	/**
	 * Returns: a new UpWakeupItem object.
	 *
	 * Since: 0.9.0
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = up_wakeup_item_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(UpWakeupItem*) p, true);
	}

	/**
	 * Gets the item cmdline.
	 *
	 * Returns: the value
	 *
	 * Since: 0.9.0
	 */
	public string getCmdline()
	{
		return Str.toString(up_wakeup_item_get_cmdline(upWakeupItem));
	}

	/**
	 * Gets the item details.
	 *
	 * Returns: the value
	 *
	 * Since: 0.9.0
	 */
	public string getDetails()
	{
		return Str.toString(up_wakeup_item_get_details(upWakeupItem));
	}

	/**
	 * Gets the item id.
	 *
	 * Returns: the value
	 *
	 * Since: 0.9.0
	 */
	public uint getId()
	{
		return up_wakeup_item_get_id(upWakeupItem);
	}

	/**
	 * Gets if the item is userspace.
	 *
	 * Returns: the value
	 *
	 * Since: 0.9.0
	 */
	public bool getIsUserspace()
	{
		return up_wakeup_item_get_is_userspace(upWakeupItem) != 0;
	}

	/**
	 * Gets the item old.
	 *
	 * Returns: the value
	 *
	 * Since: 0.9.0
	 */
	public uint getOld()
	{
		return up_wakeup_item_get_old(upWakeupItem);
	}

	/**
	 * Gets the item value.
	 *
	 * Returns: the value
	 *
	 * Since: 0.9.0
	 */
	public double getValue()
	{
		return up_wakeup_item_get_value(upWakeupItem);
	}

	/**
	 * Sets the item cmdline.
	 *
	 * Params:
	 *     cmdline = the new value
	 *
	 * Since: 0.9.0
	 */
	public void setCmdline(string cmdline)
	{
		up_wakeup_item_set_cmdline(upWakeupItem, Str.toStringz(cmdline));
	}

	/**
	 * Sets the item details.
	 *
	 * Params:
	 *     details = the new value
	 *
	 * Since: 0.9.0
	 */
	public void setDetails(string details)
	{
		up_wakeup_item_set_details(upWakeupItem, Str.toStringz(details));
	}

	/**
	 * Sets the item id.
	 *
	 * Params:
	 *     id = the new value
	 *
	 * Since: 0.9.0
	 */
	public void setId(uint id)
	{
		up_wakeup_item_set_id(upWakeupItem, id);
	}

	/**
	 * Sets if the item is userspace.
	 *
	 * Params:
	 *     isUserspace = the new value
	 *
	 * Since: 0.9.0
	 */
	public void setIsUserspace(bool isUserspace)
	{
		up_wakeup_item_set_is_userspace(upWakeupItem, isUserspace);
	}

	/**
	 * Sets the item old.
	 *
	 * Params:
	 *     old = the new value
	 *
	 * Since: 0.9.0
	 */
	public void setOld(uint old)
	{
		up_wakeup_item_set_old(upWakeupItem, old);
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
		up_wakeup_item_set_value(upWakeupItem, value);
	}
}
