module polkit.IdentityT;

public  import glib.ErrorG;
public  import glib.GException;
public  import glib.Str;
public  import gobject.ObjectG;
public  import polkit.IdentityIF;
public  import polkit.c.functions;
public  import polkit.c.types;


/**
 * #PolkitIdentity is an abstract type for representing one or more
 * identities.
 */
public template IdentityT(TStruct)
{
	/** Get the main Gtk struct */
	public PolkitIdentity* getIdentityStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return cast(PolkitIdentity*)getStruct();
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
	public bool equal(IdentityIF b)
	{
		return polkit_identity_equal(getIdentityStruct(), (b is null) ? null : b.getIdentityStruct()) != 0;
	}

	/**
	 * Gets a hash code for @identity that can be used with e.g. g_hash_table_new().
	 *
	 * Returns: A hash code.
	 */
	public uint hash()
	{
		return polkit_identity_hash(getIdentityStruct());
	}

	/**
	 * Serializes @identity to a string that can be used in
	 * polkit_identity_from_string().
	 *
	 * Returns: A string representing @identity. Free with g_free().
	 */
	public override string toString()
	{
		auto retStr = polkit_identity_to_string(getIdentityStruct());

		scope(exit) Str.freeString(retStr);
		return Str.toString(retStr);
	}
}
