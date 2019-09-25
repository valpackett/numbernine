module upower.Wakeups;

private import gio.Cancellable;
private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import glib.PtrArray;
private import gobject.ObjectG;
private import gobject.Signals;
private import std.algorithm;
private import upower.c.functions;
public  import upower.c.types;


/** */
public class Wakeups : ObjectG
{
	/** the main Gtk struct */
	protected UpWakeups* upWakeups;

	/** Get the main Gtk struct */
	public UpWakeups* getWakeupsStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return upWakeups;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)upWakeups;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (UpWakeups* upWakeups, bool ownedRef = false)
	{
		this.upWakeups = upWakeups;
		super(cast(GObject*)upWakeups, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return up_wakeups_get_type();
	}

	/**
	 * Gets a new object to allow querying the wakeups data from the server.
	 *
	 * Returns: the a new @UpWakeups object.
	 *
	 * Since: 0.9.1
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = up_wakeups_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(UpWakeups*) p, true);
	}

	/**
	 * Gets the wakeups data from the daemon.
	 *
	 * Params:
	 *     cancellable = a #GCancellable or %NULL
	 *
	 * Returns: an array of %UpWakeupItem's
	 *
	 * Since: 0.9.1
	 *
	 * Throws: GException on failure.
	 */
	public PtrArray getDataSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = up_wakeups_get_data_sync(upWakeups, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return new PtrArray(cast(GPtrArray*) p, true);
	}

	/**
	 * Returns if the daemon supports getting the wakeup data.
	 *
	 * Returns: %TRUE if supported
	 *
	 * Since: 0.9.1
	 */
	public bool getHasCapability()
	{
		return up_wakeups_get_has_capability(upWakeups) != 0;
	}

	/**
	 * Gets properties from the daemon about wakeup data.
	 *
	 * Params:
	 *     cancellable = a #GCancellable or %NULL
	 *
	 * Returns: %TRUE if supported
	 *
	 * Since: 0.9.1
	 *
	 * Throws: GException on failure.
	 */
	public bool getPropertiesSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = up_wakeups_get_properties_sync(upWakeups, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Gets the the total number of wakeups per second from the daemon.
	 *
	 * Params:
	 *     cancellable = a #GCancellable or %NULL
	 *
	 * Returns: number of wakeups per second.
	 *
	 * Since: 0.9.1
	 *
	 * Throws: GException on failure.
	 */
	public uint getTotalSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = up_wakeups_get_total_sync(upWakeups, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/** */
	gulong addOnDataChanged(void delegate(Wakeups) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "data-changed", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}

	/** */
	gulong addOnTotalChanged(void delegate(uint, Wakeups) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "total-changed", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}
}
