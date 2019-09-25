module upower.Client;

private import gio.Cancellable;
private import gio.InitableIF;
private import gio.InitableT;
private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import glib.PtrArray;
private import glib.Str;
private import gobject.ObjectG;
private import gobject.Signals;
private import std.algorithm;
private import upower.Device;
private import upower.c.functions;
public  import upower.c.types;


/** */
public class Client : ObjectG, InitableIF
{
	/** the main Gtk struct */
	protected UpClient* upClient;

	/** Get the main Gtk struct */
	public UpClient* getClientStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return upClient;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)upClient;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (UpClient* upClient, bool ownedRef = false)
	{
		this.upClient = upClient;
		super(cast(GObject*)upClient, ownedRef);
	}

	// add the Initable capabilities
	mixin InitableT!(UpClient);


	/** */
	public static GType getType()
	{
		return up_client_get_type();
	}

	/**
	 * Creates a new #UpClient object. If connecting to upowerd on D-Bus fails,
	 * this returns %NULL and prints out a warning with the error message.
	 * Consider using up_client_new_full() instead which allows you to handle errors
	 * and cancelling long operations yourself.
	 *
	 * Returns: a new UpClient object, or %NULL on failure.
	 *
	 * Since: 0.9.0
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = up_client_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(UpClient*) p, true);
	}

	/**
	 * Creates a new #UpClient object. If connecting to upowerd on D-Bus fails,
	 * % this returns %NULL and sets @error.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: a new UpClient object, or %NULL on failure.
	 *
	 * Since: 0.99.5
	 *
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(Cancellable cancellable)
	{
		GError* err = null;

		auto p = up_client_new_full((cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			throw new ConstructionException("null returned by new_full");
		}

		this(cast(UpClient*) p, true);
	}

	/**
	 * Gets a string representing the configured critical action,
	 * depending on availability.
	 *
	 * Returns: the action name, or %NULL on error.
	 *
	 * Since: 1.0
	 */
	public string getCriticalAction()
	{
		auto retStr = up_client_get_critical_action(upClient);

		scope(exit) Str.freeString(retStr);
		return Str.toString(retStr);
	}

	/**
	 * Get UPower daemon version.
	 *
	 * Returns: string containing the daemon version, e.g. 008
	 *
	 * Since: 0.9.0
	 */
	public string getDaemonVersion()
	{
		return Str.toString(up_client_get_daemon_version(upClient));
	}

	/**
	 * Get a copy of the device objects.
	 *
	 * Returns: an array of #UpDevice objects, free with g_ptr_array_unref()
	 *
	 * Since: 0.9.0
	 */
	public PtrArray getDevices()
	{
		auto p = up_client_get_devices(upClient);

		if(p is null)
		{
			return null;
		}

		return new PtrArray(cast(GPtrArray*) p, true);
	}

	/**
	 * Get the composite display device.
	 *
	 * Returns: a #UpClient object, or %NULL on error.
	 *
	 * Since: 1.0
	 */
	public Device getDisplayDevice()
	{
		auto p = up_client_get_display_device(upClient);

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Device)(cast(UpDevice*) p, true);
	}

	/**
	 * Get whether the laptop lid is closed.
	 *
	 * Returns: %TRUE if lid is closed or %FALSE otherwise.
	 *
	 * Since: 0.9.0
	 */
	public bool getLidIsClosed()
	{
		return up_client_get_lid_is_closed(upClient) != 0;
	}

	/**
	 * Get whether a laptop lid is present on this machine.
	 *
	 * Returns: %TRUE if the machine has a laptop lid
	 *
	 * Since: 0.9.2
	 */
	public bool getLidIsPresent()
	{
		return up_client_get_lid_is_present(upClient) != 0;
	}

	/**
	 * Get whether the system is running on battery power.
	 *
	 * Returns: %TRUE if the system is currently running on battery, %FALSE otherwise.
	 *
	 * Since: 0.9.0
	 */
	public bool getOnBattery()
	{
		return up_client_get_on_battery(upClient) != 0;
	}

	/**
	 * The ::device-added signal is emitted when a power device is added.
	 *
	 * Params:
	 *     device = the #UpDevice that was added.
	 *
	 * Since: 0.9.0
	 */
	gulong addOnDeviceAdded(void delegate(Device, Client) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "device-added", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}

	/**
	 * The ::device-removed signal is emitted when a power device is removed.
	 *
	 * Params:
	 *     objectPath = the object path of the #UpDevice that was removed.
	 *
	 * Since: 1.0
	 */
	gulong addOnDeviceRemoved(void delegate(string, Client) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "device-removed", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}
}
