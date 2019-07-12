module polkit.UnixUser;

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
 * An object representing a user identity on a UNIX system.
 */
public class UnixUser : ObjectG, IdentityIF
{
	/** the main Gtk struct */
	protected PolkitUnixUser* polkitUnixUser;

	/** Get the main Gtk struct */
	public PolkitUnixUser* getUnixUserStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitUnixUser;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitUnixUser;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitUnixUser* polkitUnixUser, bool ownedRef = false)
	{
		this.polkitUnixUser = polkitUnixUser;
		super(cast(GObject*)polkitUnixUser, ownedRef);
	}

	// add the Identity capabilities
	mixin IdentityT!(PolkitUnixUser);


	/** */
	public static GType getType()
	{
		return polkit_unix_user_get_type();
	}

	/**
	 * Creates a new #PolkitUnixUser object for @uid.
	 *
	 * Params:
	 *     uid = A UNIX user id.
	 *
	 * Returns: A #PolkitUnixUser object. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(int uid)
	{
		auto p = polkit_unix_user_new(uid);

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitUnixUser*) p, true);
	}

	/**
	 * Creates a new #PolkitUnixUser object for a user with the user name
	 * @name.
	 *
	 * Params:
	 *     name = A UNIX user name.
	 *
	 * Returns: A #PolkitUnixUser object or %NULL if @error is set.
	 *
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(string name)
	{
		GError* err = null;

		auto p = polkit_unix_user_new_for_name(Str.toStringz(name), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			throw new ConstructionException("null returned by new_for_name");
		}

		this(cast(PolkitUnixUser*) p, true);
	}

	/**
	 * Get the user's name.
	 *
	 * Returns: User name string or %NULL if user uid not found.
	 */
	public string getName()
	{
		return Str.toString(polkit_unix_user_get_name(polkitUnixUser));
	}

	/**
	 * Gets the UNIX user id for @user.
	 *
	 * Returns: A UNIX user id.
	 */
	public int getUid()
	{
		return polkit_unix_user_get_uid(polkitUnixUser);
	}

	/**
	 * Sets @uid for @user.
	 *
	 * Params:
	 *     uid = A UNIX user id.
	 */
	public void setUid(int uid)
	{
		polkit_unix_user_set_uid(polkitUnixUser, uid);
	}
}
