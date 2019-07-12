module polkit.UnixGroup;

private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.IdentityIF;
private import polkit.IdentityT;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * An object representing a group identity on a UNIX system.
 */
public class UnixGroup : ObjectG, IdentityIF
{
	/** the main Gtk struct */
	protected PolkitUnixGroup* polkitUnixGroup;

	/** Get the main Gtk struct */
	public PolkitUnixGroup* getUnixGroupStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitUnixGroup;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitUnixGroup;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitUnixGroup* polkitUnixGroup, bool ownedRef = false)
	{
		this.polkitUnixGroup = polkitUnixGroup;
		super(cast(GObject*)polkitUnixGroup, ownedRef);
	}

	// add the Identity capabilities
	mixin IdentityT!(PolkitUnixGroup);


	/** */
	public static GType getType()
	{
		return polkit_unix_group_get_type();
	}

	/**
	 * Creates a new #PolkitUnixGroup object for @gid.
	 *
	 * Params:
	 *     gid = A UNIX group id.
	 *
	 * Returns: A #PolkitUnixGroup object. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(int gid)
	{
		auto p = polkit_unix_group_new(gid);

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitUnixGroup*) p, true);
	}

	/**
	 * Creates a new #PolkitUnixGroup object for a group with the group name
	 * @name.
	 *
	 * Params:
	 *     name = A UNIX group name.
	 *
	 * Returns: (allow-none): A #PolkitUnixGroup object or %NULL if @error
	 *     is set.
	 *
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(string name)
	{
		GError* err = null;

		auto p = polkit_unix_group_new_for_name(Str.toStringz(name), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			throw new ConstructionException("null returned by new_for_name");
		}

		this(cast(PolkitUnixGroup*) p, true);
	}

	/**
	 * Gets the UNIX group id for @group.
	 *
	 * Returns: A UNIX group id.
	 */
	public int getGid()
	{
		return polkit_unix_group_get_gid(polkitUnixGroup);
	}

	/**
	 * Sets @gid for @group.
	 *
	 * Params:
	 *     gid = A UNIX group id.
	 */
	public void setGid(int gid)
	{
		polkit_unix_group_set_gid(polkitUnixGroup, gid);
	}
}
