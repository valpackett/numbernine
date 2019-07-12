module polkit.Details;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * An object used for passing details around.
 */
public class Details : ObjectG
{
	/** the main Gtk struct */
	protected PolkitDetails* polkitDetails;

	/** Get the main Gtk struct */
	public PolkitDetails* getDetailsStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitDetails;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitDetails;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitDetails* polkitDetails, bool ownedRef = false)
	{
		this.polkitDetails = polkitDetails;
		super(cast(GObject*)polkitDetails, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return polkit_details_get_type();
	}

	/**
	 * Creates a new #PolkitDetails object.
	 *
	 * Returns: A #PolkitDetails object. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = polkit_details_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitDetails*) p, true);
	}

	/**
	 * Gets a list of all keys on @details.
	 *
	 * Returns: %NULL if there are no keys
	 *     otherwise an array of strings that should be freed with
	 *     g_strfreev().
	 */
	public string[] getKeys()
	{
		auto retStr = polkit_details_get_keys(polkitDetails);

		scope(exit) Str.freeStringArray(retStr);
		return Str.toStringArray(retStr);
	}

	/**
	 * Inserts a copy of @key and @value on @details.
	 *
	 * If @value is %NULL, the key will be removed.
	 *
	 * Params:
	 *     key = A key.
	 *     value = A value.
	 */
	public void insert(string key, string value)
	{
		polkit_details_insert(polkitDetails, Str.toStringz(key), Str.toStringz(value));
	}

	/**
	 * Gets the value for @key on @details.
	 *
	 * Params:
	 *     key = A key.
	 *
	 * Returns: %NULL if there is no value for @key, otherwise a string owned by @details.
	 */
	public string lookup(string key)
	{
		return Str.toString(polkit_details_lookup(polkitDetails, Str.toStringz(key)));
	}
}
