module polkit.AuthorizationResult;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.Details;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * This class represents the result you get when checking for an authorization.
 */
public class AuthorizationResult : ObjectG
{
	/** the main Gtk struct */
	protected PolkitAuthorizationResult* polkitAuthorizationResult;

	/** Get the main Gtk struct */
	public PolkitAuthorizationResult* getAuthorizationResultStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitAuthorizationResult;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitAuthorizationResult;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitAuthorizationResult* polkitAuthorizationResult, bool ownedRef = false)
	{
		this.polkitAuthorizationResult = polkitAuthorizationResult;
		super(cast(GObject*)polkitAuthorizationResult, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return polkit_authorization_result_get_type();
	}

	/**
	 * Creates a new #PolkitAuthorizationResult object.
	 *
	 * Params:
	 *     isAuthorized = Whether the subject is authorized.
	 *     isChallenge = Whether the subject is authorized if more
	 *         information is provided. Must be %FALSE unless @is_authorized is
	 *         %TRUE.
	 *     details = Must be %NULL unless @is_authorized is %TRUE
	 *
	 * Returns: A #PolkitAuthorizationResult object. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(bool isAuthorized, bool isChallenge, Details details)
	{
		auto p = polkit_authorization_result_new(isAuthorized, isChallenge, (details is null) ? null : details.getDetailsStruct());

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitAuthorizationResult*) p, true);
	}

	/**
	 * Gets the details about the result.
	 *
	 * Returns: A #PolkitDetails object or
	 *     %NULL if there are no details. This object is owned by @result and
	 *     should not be freed by the caller.
	 */
	public Details getDetails()
	{
		auto p = polkit_authorization_result_get_details(polkitAuthorizationResult);

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Details)(cast(PolkitDetails*) p);
	}

	/**
	 * Gets whether the authentication request was dismissed / canceled by the user.
	 *
	 * This method simply reads the value of the key/value pair in @details with the
	 * key <literal>polkit.dismissed</literal>.
	 *
	 * Returns: %TRUE if the authentication request was dismissed, %FALSE otherwise.
	 *
	 * Since: 0.101
	 */
	public bool getDismissed()
	{
		return polkit_authorization_result_get_dismissed(polkitAuthorizationResult) != 0;
	}

	/**
	 * Gets whether the subject is authorized.
	 *
	 * If the authorization is temporary, use polkit_authorization_result_get_temporary_authorization_id()
	 * to get the opaque identifier for the temporary authorization.
	 *
	 * Returns: Whether the subject is authorized.
	 */
	public bool getIsAuthorized()
	{
		return polkit_authorization_result_get_is_authorized(polkitAuthorizationResult) != 0;
	}

	/**
	 * Gets whether the subject is authorized if more information is provided.
	 *
	 * Returns: Whether the subject is authorized if more information is provided.
	 */
	public bool getIsChallenge()
	{
		return polkit_authorization_result_get_is_challenge(polkitAuthorizationResult) != 0;
	}

	/**
	 * Gets whether authorization is retained if obtained via authentication. This can only be the case
	 * if @result indicates that the subject can obtain authorization after challenge (cf.
	 * polkit_authorization_result_get_is_challenge()), e.g. when the subject is not already authorized (cf.
	 * polkit_authorization_result_get_is_authorized()).
	 *
	 * If the subject is already authorized, use polkit_authorization_result_get_temporary_authorization_id()
	 * to check if the authorization is temporary.
	 *
	 * This method simply reads the value of the key/value pair in @details with the
	 * key <literal>polkit.retains_authorization_after_challenge</literal>.
	 *
	 * Returns: %TRUE if the authorization is or will be temporary.
	 */
	public bool getRetainsAuthorization()
	{
		return polkit_authorization_result_get_retains_authorization(polkitAuthorizationResult) != 0;
	}

	/**
	 * Gets the opaque temporary authorization id for @result if @result indicates the
	 * subject is authorized and the authorization is temporary rather than one-shot or
	 * permanent.
	 *
	 * You can use this string together with the result from
	 * polkit_authority_enumerate_temporary_authorizations() to get more details
	 * about the temporary authorization or polkit_authority_revoke_temporary_authorization_by_id()
	 * to revoke the temporary authorization.
	 *
	 * If the subject is not authorized, use polkit_authorization_result_get_retains_authorization()
	 * to check if the authorization will be retained if obtained via authentication.
	 *
	 * This method simply reads the value of the key/value pair in @details with the
	 * key <literal>polkit.temporary_authorization_id</literal>.
	 *
	 * Returns: The opaque temporary authorization id for
	 *     @result or %NULL if not available. Do not free this string, it
	 *     is owned by @result.
	 */
	public string getTemporaryAuthorizationId()
	{
		return Str.toString(polkit_authorization_result_get_temporary_authorization_id(polkitAuthorizationResult));
	}
}
