module polkit.IdentityIF;

private import glib.ErrorG;
private import glib.GException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.IdentityIF;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * #PolkitIdentity is an abstract type for representing one or more
 * identities.
 */
public interface IdentityIF{
	/** Get the main Gtk struct */
	public PolkitIdentity* getIdentityStruct(bool transferOwnership = false);

	/** the main Gtk struct as a void* */
	protected void* getStruct();


	/** */
	public static GType getType()
	{
		return polkit_identity_get_type();
	}

	/**
	 * Creates an object from @str that implements the #PolkitIdentity
	 * interface.
	 *
	 * Params:
	 *     str = A string obtained from polkit_identity_to_string().
	 *
	 * Returns: A #PolkitIdentity or %NULL
	 *     if @error is set. Free with g_object_unref().
	 *
	 * Throws: GException on failure.
	 */
	public static IdentityIF fromString(string str)
	{
		GError* err = null;

		auto p = polkit_identity_from_string(Str.toStringz(str), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(IdentityIF)(cast(PolkitIdentity*) p, true);
	}

	/**
	 * Checks if @a and @b are equal, ie. represent the same identity.
	 *
	 * This function can be used in e.g. g_hash_table_new().
	 *
	 * Params:
	 *     b = A #PolkitIdentity.
	 *
	 * Returns: %TRUE if @a and @b are equal, %FALSE otherwise.
	 */
	public bool equal(IdentityIF b);

	/**
	 * Gets a hash code for @identity that can be used with e.g. g_hash_table_new().
	 *
	 * Returns: A hash code.
	 */
	public uint hash();

	/**
	 * Serializes @identity to a string that can be used in
	 * polkit_identity_from_string().
	 *
	 * Returns: A string representing @identity. Free with g_free().
	 */
	public string toString();
}
