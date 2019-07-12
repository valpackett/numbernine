module polkit.SystemBusName;

private import gio.Cancellable;
private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.SubjectIF;
private import polkit.SubjectT;
private import polkit.UnixUser;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * An object that represents a process owning a unique name on the system bus.
 */
public class SystemBusName : ObjectG, SubjectIF
{
	/** the main Gtk struct */
	protected PolkitSystemBusName* polkitSystemBusName;

	/** Get the main Gtk struct */
	public PolkitSystemBusName* getSystemBusNameStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitSystemBusName;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitSystemBusName;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitSystemBusName* polkitSystemBusName, bool ownedRef = false)
	{
		this.polkitSystemBusName = polkitSystemBusName;
		super(cast(GObject*)polkitSystemBusName, ownedRef);
	}

	// add the Subject capabilities
	mixin SubjectT!(PolkitSystemBusName);


	/** */
	public static GType getType()
	{
		return polkit_system_bus_name_get_type();
	}

	/**
	 * Creates a new #PolkitSystemBusName for @name.
	 *
	 * Params:
	 *     name = A unique system bus name.
	 *
	 * Returns: A #PolkitSystemBusName. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(string name)
	{
		auto p = polkit_system_bus_name_new(Str.toStringz(name));

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitSystemBusName*) p, true);
	}

	/**
	 * Gets the unique system bus name for @system_bus_name.
	 *
	 * Returns: The unique system bus name for @system_bus_name. Do not
	 *     free, this string is owned by @system_bus_name.
	 */
	public string getName()
	{
		return Str.toString(polkit_system_bus_name_get_name(polkitSystemBusName));
	}

	/**
	 * Synchronously gets a #PolkitUnixProcess object for @system_bus_name
	 * - the calling thread is blocked until a reply is received.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A #PolkitUnixProcess object or %NULL if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public SubjectIF getProcessSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_system_bus_name_get_process_sync(polkitSystemBusName, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(SubjectIF)(cast(PolkitSubject*) p, true);
	}

	/**
	 * Synchronously gets a #PolkitUnixUser object for @system_bus_name;
	 * the calling thread is blocked until a reply is received.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A #PolkitUnixUser object or %NULL if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public UnixUser getUserSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_system_bus_name_get_user_sync(polkitSystemBusName, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(UnixUser)(cast(PolkitUnixUser*) p, true);
	}

	/**
	 * Sets the unique system bus name for @system_bus_name.
	 *
	 * Params:
	 *     name = A unique system bus name.
	 */
	public void setName(string name)
	{
		polkit_system_bus_name_set_name(polkitSystemBusName, Str.toStringz(name));
	}
}
