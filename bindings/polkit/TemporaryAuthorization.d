module polkit.TemporaryAuthorization;

private import glib.Str;
private import gobject.ObjectG;
private import polkit.SubjectIF;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * Object used to describe a temporary authorization.
 */
public class TemporaryAuthorization : ObjectG
{
	/** the main Gtk struct */
	protected PolkitTemporaryAuthorization* polkitTemporaryAuthorization;

	/** Get the main Gtk struct */
	public PolkitTemporaryAuthorization* getTemporaryAuthorizationStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitTemporaryAuthorization;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitTemporaryAuthorization;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitTemporaryAuthorization* polkitTemporaryAuthorization, bool ownedRef = false)
	{
		this.polkitTemporaryAuthorization = polkitTemporaryAuthorization;
		super(cast(GObject*)polkitTemporaryAuthorization, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return polkit_temporary_authorization_get_type();
	}

	/**
	 * Gets the action that @authorization is for.
	 *
	 * Returns: A string owned by @authorization. Do not free.
	 */
	public string getActionId()
	{
		return Str.toString(polkit_temporary_authorization_get_action_id(polkitTemporaryAuthorization));
	}

	/**
	 * Gets the opaque identifier for @authorization.
	 *
	 * Returns: A string owned by @authorization. Do not free.
	 */
	public string getId()
	{
		return Str.toString(polkit_temporary_authorization_get_id(polkitTemporaryAuthorization));
	}

	/**
	 * Gets the subject that @authorization is for.
	 *
	 * Returns: A #PolkitSubject, free with g_object_unref().
	 */
	public SubjectIF getSubject()
	{
		auto p = polkit_temporary_authorization_get_subject(polkitTemporaryAuthorization);

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(SubjectIF)(cast(PolkitSubject*) p, true);
	}

	/**
	 * Gets the time when @authorization will expire.
	 *
	 * (Note that the PolicyKit daemon is using monotonic time internally
	 * so the returned value may change if system time changes.)
	 *
	 * Returns: Seconds since the Epoch Jan 1. 1970, 0:00 UTC.
	 */
	public ulong getTimeExpires()
	{
		return polkit_temporary_authorization_get_time_expires(polkitTemporaryAuthorization);
	}

	/**
	 * Gets the time when @authorization was obtained.
	 *
	 * (Note that the PolicyKit daemon is using monotonic time internally
	 * so the returned value may change if system time changes.)
	 *
	 * Returns: Seconds since the Epoch Jan 1. 1970, 0:00 UTC.
	 */
	public ulong getTimeObtained()
	{
		return polkit_temporary_authorization_get_time_obtained(polkitTemporaryAuthorization);
	}
}
