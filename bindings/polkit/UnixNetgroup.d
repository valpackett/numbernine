module polkit.UnixNetgroup;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.IdentityIF;
private import polkit.IdentityT;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * An object representing a netgroup identity on a UNIX system.
 */
public class UnixNetgroup : ObjectG, IdentityIF
{
	/** the main Gtk struct */
	protected PolkitUnixNetgroup* polkitUnixNetgroup;

	/** Get the main Gtk struct */
	public PolkitUnixNetgroup* getUnixNetgroupStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitUnixNetgroup;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitUnixNetgroup;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitUnixNetgroup* polkitUnixNetgroup, bool ownedRef = false)
	{
		this.polkitUnixNetgroup = polkitUnixNetgroup;
		super(cast(GObject*)polkitUnixNetgroup, ownedRef);
	}

	// add the Identity capabilities
	mixin IdentityT!(PolkitUnixNetgroup);


	/** */
	public static GType getType()
	{
		return polkit_unix_netgroup_get_type();
	}

	/**
	 * Creates a new #PolkitUnixNetgroup object for @name.
	 *
	 * Params:
	 *     name = A netgroup name.
	 *
	 * Returns: A #PolkitUnixNetgroup object. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(string name)
	{
		auto p = polkit_unix_netgroup_new(Str.toStringz(name));

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitUnixNetgroup*) p, true);
	}

	/**
	 * Gets the netgroup name for @group.
	 *
	 * Returns: A netgroup name string.
	 */
	public string getName()
	{
		return Str.toString(polkit_unix_netgroup_get_name(polkitUnixNetgroup));
	}

	/**
	 * Sets @name for @group.
	 *
	 * Params:
	 *     name = A netgroup name.
	 */
	public void setName(string name)
	{
		polkit_unix_netgroup_set_name(polkitUnixNetgroup, Str.toStringz(name));
	}
}
