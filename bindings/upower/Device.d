module upower.Device;

private import gio.Cancellable;
private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import glib.PtrArray;
private import glib.Str;
private import gobject.ObjectG;
private import upower.c.functions;
public  import upower.c.types;


/** */
public class Device : ObjectG
{
	/** the main Gtk struct */
	protected UpDevice* upDevice;

	/** Get the main Gtk struct */
	public UpDevice* getDeviceStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return upDevice;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)upDevice;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (UpDevice* upDevice, bool ownedRef = false)
	{
		this.upDevice = upDevice;
		super(cast(GObject*)upDevice, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return up_device_get_type();
	}

	/**
	 * Creates a new #UpDevice object.
	 *
	 * Returns: a new UpDevice object.
	 *
	 * Since: 0.9.0
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = up_device_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(UpDevice*) p, true);
	}

	/**
	 * Converts a string to a #UpDeviceKind.
	 *
	 * Returns: enumerated value
	 *
	 * Since: 0.9.0
	 */
	public static UpDeviceKind kindFromString(string type)
	{
		return up_device_kind_from_string(Str.toStringz(type));
	}

	/**
	 * Converts a #UpDeviceKind to a string.
	 *
	 * Returns: identifier string
	 *
	 * Since: 0.9.0
	 */
	public static string kindToString(UpDeviceKind typeEnum)
	{
		return Str.toString(up_device_kind_to_string(typeEnum));
	}

	/**
	 * Converts a string to a #UpDeviceLevel.
	 *
	 * Returns: enumerated value
	 *
	 * Since: 1.0
	 */
	public static UpDeviceLevel levelFromString(string level)
	{
		return up_device_level_from_string(Str.toStringz(level));
	}

	/**
	 * Converts a #UpDeviceLevel to a string.
	 *
	 * Returns: identifier string
	 *
	 * Since: 1.0
	 */
	public static string levelToString(UpDeviceLevel levelEnum)
	{
		return Str.toString(up_device_level_to_string(levelEnum));
	}

	/**
	 * Converts a string to a #UpDeviceState.
	 *
	 * Returns: enumerated value
	 *
	 * Since: 0.9.0
	 */
	public static UpDeviceState stateFromString(string state)
	{
		return up_device_state_from_string(Str.toStringz(state));
	}

	/**
	 * Converts a #UpDeviceState to a string.
	 *
	 * Returns: identifier string
	 *
	 * Since: 0.9.0
	 */
	public static string stateToString(UpDeviceState stateEnum)
	{
		return Str.toString(up_device_state_to_string(stateEnum));
	}

	/**
	 * Converts a string to a #UpDeviceTechnology.
	 *
	 * Returns: enumerated value
	 *
	 * Since: 0.9.0
	 */
	public static UpDeviceTechnology technologyFromString(string technology)
	{
		return up_device_technology_from_string(Str.toStringz(technology));
	}

	/**
	 * Converts a #UpDeviceTechnology to a string.
	 *
	 * Returns: identifier string
	 *
	 * Since: 0.9.0
	 */
	public static string technologyToString(UpDeviceTechnology technologyEnum)
	{
		return Str.toString(up_device_technology_to_string(technologyEnum));
	}

	/**
	 * Gets the device history.
	 *
	 * Params:
	 *     type = The type of history, known values are "rate" and "charge".
	 *     timespec = the amount of time to look back into time.
	 *     resolution = the resolution of data.
	 *     cancellable = a #GCancellable or %NULL
	 *
	 * Returns: an array of #UpHistoryItem's, with the most
	 *     recent one being first; %NULL if @error is set or @device is
	 *     invalid
	 *
	 * Since: 0.9.0
	 *
	 * Throws: GException on failure.
	 */
	public PtrArray getHistorySync(string type, uint timespec, uint resolution, Cancellable cancellable)
	{
		GError* err = null;

		auto p = up_device_get_history_sync(upDevice, Str.toStringz(type), timespec, resolution, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

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
	 * Gets the object path for the device.
	 *
	 * Returns: the object path, or %NULL
	 *
	 * Since: 0.9.0
	 */
	public string getObjectPath()
	{
		return Str.toString(up_device_get_object_path(upDevice));
	}

	/**
	 * Gets the device current statistics.
	 *
	 * Params:
	 *     type = the type of statistics.
	 *     cancellable = a #GCancellable or %NULL
	 *
	 * Returns: an array of #UpStatsItem's, else #NULL and @error is used
	 *
	 * Since: 0.9.0
	 *
	 * Throws: GException on failure.
	 */
	public PtrArray getStatisticsSync(string type, Cancellable cancellable)
	{
		GError* err = null;

		auto p = up_device_get_statistics_sync(upDevice, Str.toStringz(type), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

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
	 * Refreshes properties on the device.
	 * This function is normally not required.
	 *
	 * Params:
	 *     cancellable = a #GCancellable or %NULL
	 *
	 * Returns: #TRUE for success, else #FALSE and @error is used
	 *
	 * Since: 0.9.0
	 *
	 * Throws: GException on failure.
	 */
	public bool refreshSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = up_device_refresh_sync(upDevice, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Sets the object path of the object and fills up initial properties.
	 *
	 * Params:
	 *     objectPath = The UPower object path.
	 *     cancellable = a #GCancellable or %NULL
	 *
	 * Returns: #TRUE for success, else #FALSE and @error is used
	 *
	 * Since: 0.9.0
	 *
	 * Throws: GException on failure.
	 */
	public bool setObjectPathSync(string objectPath, Cancellable cancellable)
	{
		GError* err = null;

		auto p = up_device_set_object_path_sync(upDevice, Str.toStringz(objectPath), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Converts the device to a string description.
	 *
	 * Returns: text representation of #UpDevice
	 *
	 * Since: 0.9.0
	 */
	public string toText()
	{
		auto retStr = up_device_to_text(upDevice);

		scope(exit) Str.freeString(retStr);
		return Str.toString(retStr);
	}
}
