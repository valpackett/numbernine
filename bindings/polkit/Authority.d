module polkit.Authority;

private import gio.AsyncInitableIF;
private import gio.AsyncInitableT;
private import gio.AsyncResultIF;
private import gio.Cancellable;
private import gio.InitableIF;
private import gio.InitableT;
private import glib.ErrorG;
private import glib.GException;
private import glib.ListG;
private import glib.Str;
private import glib.Variant;
private import gobject.ObjectG;
private import gobject.Signals;
private import polkit.AuthorizationResult;
private import polkit.Details;
private import polkit.IdentityIF;
private import polkit.SubjectIF;
private import polkit.c.functions;
public  import polkit.c.types;
private import std.algorithm;


/**
 * #PolkitAuthority is used for checking whether a given subject is
 * authorized to perform a given action. Typically privileged system
 * daemons or suid helpers will use this when handling requests from
 * untrusted clients.
 * 
 * User sessions can register an authentication agent with the
 * authority. This is used for requests from untrusted clients where
 * system policy requires that the user needs to acknowledge (through
 * proving he is the user or the administrator) a given action. See
 * #PolkitAgentListener and #PolkitAgentSession for details.
 */
public class Authority : ObjectG, AsyncInitableIF, InitableIF
{
	/** the main Gtk struct */
	protected PolkitAuthority* polkitAuthority;

	/** Get the main Gtk struct */
	public PolkitAuthority* getAuthorityStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitAuthority;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitAuthority;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitAuthority* polkitAuthority, bool ownedRef = false)
	{
		this.polkitAuthority = polkitAuthority;
		super(cast(GObject*)polkitAuthority, ownedRef);
	}

	// add the AsyncInitable capabilities
	mixin AsyncInitableT!(PolkitAuthority);

	// add the Initable capabilities
	mixin InitableT!(PolkitAuthority);


	/** */
	public static GType getType()
	{
		return polkit_authority_get_type();
	}

	/**
	 * (deprecated)
	 *
	 * Returns: value
	 */
	public static Authority get()
	{
		auto p = polkit_authority_get();

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Authority)(cast(PolkitAuthority*) p, true);
	}

	/**
	 * Asynchronously gets a reference to the authority.
	 *
	 * This is an asynchronous failable function. When the result is
	 * ready, @callback will be invoked in the <link
	 * linkend="g-main-context-push-thread-default">thread-default main
	 * loop</link> of the thread you are calling this method from and you
	 * can use polkit_authority_get_finish() to get the result. See
	 * polkit_authority_get_sync() for the synchronous version.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public static void getAsync(Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_get_async((cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes an operation started with polkit_authority_get_async().
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the #GAsyncReadyCallback passed to polkit_authority_get_async().
	 *
	 * Returns: A #PolkitAuthority. Free it with
	 *     g_object_unref() when done with it.
	 *
	 * Throws: GException on failure.
	 */
	public static Authority getFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_get_finish((res is null) ? null : res.getAsyncResultStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Authority)(cast(PolkitAuthority*) p, true);
	}

	/**
	 * Synchronously gets a reference to the authority.
	 *
	 * This is a synchronous failable function - the calling thread is
	 * blocked until a reply is received. See polkit_authority_get_async()
	 * for the asynchronous version.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A #PolkitAuthority. Free it with
	 *     g_object_unref() when done with it.
	 *
	 * Throws: GException on failure.
	 */
	public static Authority getSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_get_sync((cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(Authority)(cast(PolkitAuthority*) p, true);
	}

	/**
	 * Asynchronously provide response that @identity successfully authenticated
	 * for the authentication request identified by @cookie.
	 *
	 * This function is only used by the privileged bits of an authentication agent.
	 * It will fail if the caller is not sufficiently privileged (typically uid 0).
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_authority_authentication_agent_response_finish() to get the
	 * result of the operation.
	 *
	 * Params:
	 *     cookie = The cookie passed to the authentication agent from the authority.
	 *     identity = The identity that was authenticated.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void authenticationAgentResponse(string cookie, IdentityIF identity, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_authentication_agent_response(polkitAuthority, Str.toStringz(cookie), (identity is null) ? null : identity.getIdentityStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes providing response from an authentication agent.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: %TRUE if @authority acknowledged the call, %FALSE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool authenticationAgentResponseFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_authentication_agent_response_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Provide response that @identity successfully authenticated for the
	 * authentication request identified by @cookie. See polkit_authority_authentication_agent_response()
	 * for limitations on who is allowed is to call this method.
	 *
	 * The calling thread is blocked until a reply is received. See
	 * polkit_authority_authentication_agent_response() for the
	 * asynchronous version.
	 *
	 * Params:
	 *     cookie = The cookie passed to the authentication agent from the authority.
	 *     identity = The identity that was authenticated.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %TRUE if @authority acknowledged the call, %FALSE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool authenticationAgentResponseSync(string cookie, IdentityIF identity, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_authentication_agent_response_sync(polkitAuthority, Str.toStringz(cookie), (identity is null) ? null : identity.getIdentityStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Asynchronously checks if @subject is authorized to perform the action represented
	 * by @action_id.
	 *
	 * Note that %POLKIT_CHECK_AUTHORIZATION_FLAGS_ALLOW_USER_INTERACTION
	 * <emphasis>SHOULD</emphasis> be passed <emphasis>ONLY</emphasis> if
	 * the event that triggered the authorization check is stemming from
	 * an user action, e.g. the user pressing a button or attaching a
	 * device.
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_authority_check_authorization_finish() to get the result of
	 * the operation.
	 *
	 * Known keys in @details include <literal>polkit.message</literal>
	 * and <literal>polkit.gettext_domain</literal> that can be used to
	 * override the message shown to the user. See the documentation for
	 * the <link linkend="eggdbus-method-org.freedesktop.PolicyKit1.Authority.CheckAuthorization">D-Bus method</link> for more details.
	 *
	 * If @details is non-empty then the request will fail with
	 * #POLKIT_ERROR_FAILED unless the process doing the check itsef is
	 * sufficiently authorized (e.g. running as uid 0).
	 *
	 * Params:
	 *     subject = A #PolkitSubject.
	 *     actionId = The action to check for.
	 *     details = Details about the action or %NULL.
	 *     flags = A set of #PolkitCheckAuthorizationFlags.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void checkAuthorization(SubjectIF subject, string actionId, Details details, PolkitCheckAuthorizationFlags flags, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_check_authorization(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(actionId), (details is null) ? null : details.getDetailsStruct(), flags, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes checking if a subject is authorized for an action.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: A #PolkitAuthorizationResult or %NULL if
	 *     @error is set. Free with g_object_unref().
	 *
	 * Throws: GException on failure.
	 */
	public AuthorizationResult checkAuthorizationFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_check_authorization_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(AuthorizationResult)(cast(PolkitAuthorizationResult*) p, true);
	}

	/**
	 * Checks if @subject is authorized to perform the action represented
	 * by @action_id.
	 *
	 * Note that %POLKIT_CHECK_AUTHORIZATION_FLAGS_ALLOW_USER_INTERACTION
	 * <emphasis>SHOULD</emphasis> be passed <emphasis>ONLY</emphasis> if
	 * the event that triggered the authorization check is stemming from
	 * an user action, e.g. the user pressing a button or attaching a
	 * device.
	 *
	 * Note the calling thread is blocked until a reply is received. You
	 * should therefore <emphasis>NEVER</emphasis> do this from a GUI
	 * thread or a daemon service thread when using the
	 * %POLKIT_CHECK_AUTHORIZATION_FLAGS_ALLOW_USER_INTERACTION flag. This
	 * is because it may potentially take minutes (or even hours) for the
	 * operation to complete because it involves waiting for the user to
	 * authenticate.
	 *
	 * Known keys in @details include <literal>polkit.message</literal>
	 * and <literal>polkit.gettext_domain</literal> that can be used to
	 * override the message shown to the user. See the documentation for
	 * the <link linkend="eggdbus-method-org.freedesktop.PolicyKit1.Authority.CheckAuthorization">D-Bus method</link> for more details.
	 *
	 * Params:
	 *     subject = A #PolkitSubject.
	 *     actionId = The action to check for.
	 *     details = Details about the action or %NULL.
	 *     flags = A set of #PolkitCheckAuthorizationFlags.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A #PolkitAuthorizationResult or %NULL if @error is set. Free with g_object_unref().
	 *
	 * Throws: GException on failure.
	 */
	public AuthorizationResult checkAuthorizationSync(SubjectIF subject, string actionId, Details details, PolkitCheckAuthorizationFlags flags, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_check_authorization_sync(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(actionId), (details is null) ? null : details.getDetailsStruct(), flags, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(AuthorizationResult)(cast(PolkitAuthorizationResult*) p, true);
	}

	/**
	 * Asynchronously retrieves all registered actions.
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call polkit_authority_enumerate_actions_finish()
	 * to get the result of the operation.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void enumerateActions(Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_enumerate_actions(polkitAuthority, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes retrieving all registered actions.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: A list of
	 *     #PolkitActionDescription objects or %NULL if @error is set. The returned
	 *     list should be freed with g_list_free() after each element have been freed
	 *     with g_object_unref().
	 *
	 * Throws: GException on failure.
	 */
	public ListG enumerateActionsFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_enumerate_actions_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return new ListG(cast(GList*) p, true);
	}

	/**
	 * Synchronously retrieves all registered actions - the calling thread
	 * is blocked until a reply is received. See
	 * polkit_authority_enumerate_actions() for the asynchronous version.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A list of
	 *     #PolkitActionDescription or %NULL if @error is set. The returned list should
	 *     be freed with g_list_free() after each element have been freed with
	 *     g_object_unref().
	 *
	 * Throws: GException on failure.
	 */
	public ListG enumerateActionsSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_enumerate_actions_sync(polkitAuthority, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return new ListG(cast(GList*) p, true);
	}

	/**
	 * Asynchronously gets all temporary authorizations for @subject.
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_authority_enumerate_temporary_authorizations_finish() to get
	 * the result of the operation.
	 *
	 * Params:
	 *     subject = A #PolkitSubject, typically a #PolkitUnixSession.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void enumerateTemporaryAuthorizations(SubjectIF subject, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_enumerate_temporary_authorizations(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes retrieving all registered actions.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: A
	 *     list of #PolkitTemporaryAuthorization objects or %NULL if @error is set. The
	 *     returned list should be freed with g_list_free() after each element have
	 *     been freed with g_object_unref().
	 *
	 * Throws: GException on failure.
	 */
	public ListG enumerateTemporaryAuthorizationsFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_enumerate_temporary_authorizations_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return new ListG(cast(GList*) p, true);
	}

	/**
	 * Synchronousky gets all temporary authorizations for @subject.
	 *
	 * The calling thread is blocked until a reply is received. See
	 * polkit_authority_enumerate_temporary_authorizations() for the
	 * asynchronous version.
	 *
	 * Params:
	 *     subject = A #PolkitSubject, typically a #PolkitUnixSession.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A
	 *     list of #PolkitTemporaryAuthorization objects or %NULL if @error is set. The
	 *     returned list should be freed with g_list_free() after each element have
	 *     been freed with g_object_unref().
	 *
	 * Throws: GException on failure.
	 */
	public ListG enumerateTemporaryAuthorizationsSync(SubjectIF subject, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_enumerate_temporary_authorizations_sync(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return new ListG(cast(GList*) p, true);
	}

	/**
	 * Gets the features supported by the authority backend.
	 *
	 * Returns: Flags from #PolkitAuthorityFeatures.
	 */
	public PolkitAuthorityFeatures getBackendFeatures()
	{
		return polkit_authority_get_backend_features(polkitAuthority);
	}

	/**
	 * Gets the name of the authority backend.
	 *
	 * Returns: The name of the backend.
	 */
	public string getBackendName()
	{
		return Str.toString(polkit_authority_get_backend_name(polkitAuthority));
	}

	/**
	 * Gets the version of the authority backend.
	 *
	 * Returns: The version string for the backend.
	 */
	public string getBackendVersion()
	{
		return Str.toString(polkit_authority_get_backend_version(polkitAuthority));
	}

	/**
	 * The unique name on the system message bus of the owner of the name
	 * <literal>org.freedesktop.PolicyKit1</literal> or %NULL if no-one
	 * currently owns the name. You may connect to the #GObject::notify
	 * signal to track changes to the #PolkitAuthority:owner property.
	 *
	 * Returns: %NULL or a string that should be freed with g_free().
	 */
	public string getOwner()
	{
		auto retStr = polkit_authority_get_owner(polkitAuthority);

		scope(exit) Str.freeString(retStr);
		return Str.toString(retStr);
	}

	/**
	 * Asynchronously registers an authentication agent.
	 *
	 * Note that this should be called by the same effective UID which will be
	 * the real UID using the #PolkitAgentSession API or otherwise calling
	 * polkit_authority_authentication_agent_response().
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_authority_register_authentication_agent_finish() to get the
	 * result of the operation.
	 *
	 * Params:
	 *     subject = The subject the authentication agent is for, typically a #PolkitUnixSession object.
	 *     locale = The locale of the authentication agent.
	 *     objectPath = The object path for the authentication agent.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void registerAuthenticationAgent(SubjectIF subject, string locale, string objectPath, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_register_authentication_agent(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(locale), Str.toStringz(objectPath), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes registering an authentication agent.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: %TRUE if the authentication agent was successfully registered, %FALSE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool registerAuthenticationAgentFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_register_authentication_agent_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Registers an authentication agent.
	 *
	 * Note that this should be called by the same effective UID which will be
	 * the real UID using the #PolkitAgentSession API or otherwise calling
	 * polkit_authority_authentication_agent_response().
	 *
	 * The calling thread is blocked
	 * until a reply is received. See
	 * polkit_authority_register_authentication_agent() for the
	 * asynchronous version.
	 *
	 * Params:
	 *     subject = The subject the authentication agent is for, typically a #PolkitUnixSession object.
	 *     locale = The locale of the authentication agent.
	 *     objectPath = The object path for the authentication agent.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %TRUE if the authentication agent was successfully registered, %FALSE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool registerAuthenticationAgentSync(SubjectIF subject, string locale, string objectPath, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_register_authentication_agent_sync(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(locale), Str.toStringz(objectPath), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Asynchronously registers an authentication agent.
	 *
	 * Note that this should be called by the same effective UID which will be
	 * the real UID using the #PolkitAgentSession API or otherwise calling
	 * polkit_authority_authentication_agent_response().
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_authority_register_authentication_agent_with_options_finish() to get the
	 * result of the operation.
	 *
	 * Params:
	 *     subject = The subject the authentication agent is for, typically a #PolkitUnixSession object.
	 *     locale = The locale of the authentication agent.
	 *     objectPath = The object path for the authentication agent.
	 *     options = A #GVariant with options or %NULL.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void registerAuthenticationAgentWithOptions(SubjectIF subject, string locale, string objectPath, Variant options, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_register_authentication_agent_with_options(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(locale), Str.toStringz(objectPath), (options is null) ? null : options.getVariantStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes registering an authentication agent.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: %TRUE if the authentication agent was successfully registered, %FALSE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool registerAuthenticationAgentWithOptionsFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_register_authentication_agent_with_options_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Registers an authentication agent.
	 *
	 * Note that this should be called by the same effective UID which will be
	 * the real UID using the #PolkitAgentSession API or otherwise calling
	 * polkit_authority_authentication_agent_response().
	 *
	 * The calling thread is blocked
	 * until a reply is received. See
	 * polkit_authority_register_authentication_agent_with_options() for the
	 * asynchronous version.
	 *
	 * Params:
	 *     subject = The subject the authentication agent is for, typically a #PolkitUnixSession object.
	 *     locale = The locale of the authentication agent.
	 *     objectPath = The object path for the authentication agent.
	 *     options = A #GVariant with options or %NULL.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %TRUE if the authentication agent was successfully registered, %FALSE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool registerAuthenticationAgentWithOptionsSync(SubjectIF subject, string locale, string objectPath, Variant options, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_register_authentication_agent_with_options_sync(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(locale), Str.toStringz(objectPath), (options is null) ? null : options.getVariantStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Asynchronously revoke a temporary authorization.
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_authority_revoke_temporary_authorization_by_id_finish() to
	 * get the result of the operation.
	 *
	 * Params:
	 *     id = The opaque identifier for the temporary authorization.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void revokeTemporaryAuthorizationById(string id, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_revoke_temporary_authorization_by_id(polkitAuthority, Str.toStringz(id), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes revoking a temporary authorization by id.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: %TRUE if the temporary authorization was revoked, %FALSE if error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool revokeTemporaryAuthorizationByIdFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_revoke_temporary_authorization_by_id_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Synchronously revokes a temporary authorization.
	 *
	 * The calling thread is blocked until a reply is received. See
	 * polkit_authority_revoke_temporary_authorization_by_id() for the
	 * asynchronous version.
	 *
	 * Params:
	 *     id = The opaque identifier for the temporary authorization.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %TRUE if the temporary authorization was revoked, %FALSE if error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool revokeTemporaryAuthorizationByIdSync(string id, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_revoke_temporary_authorization_by_id_sync(polkitAuthority, Str.toStringz(id), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Asynchronously revokes all temporary authorizations for @subject.
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_authority_revoke_temporary_authorizations_finish() to get
	 * the result of the operation.
	 *
	 * Params:
	 *     subject = The subject to revoke authorizations from, typically a #PolkitUnixSession.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void revokeTemporaryAuthorizations(SubjectIF subject, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_revoke_temporary_authorizations(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes revoking temporary authorizations.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: %TRUE if all the temporary authorizations was revoked, %FALSE if error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool revokeTemporaryAuthorizationsFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_revoke_temporary_authorizations_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Synchronously revokes all temporary authorization from @subject.
	 *
	 * The calling thread is blocked until a reply is received. See
	 * polkit_authority_revoke_temporary_authorizations() for the
	 * asynchronous version.
	 *
	 * Params:
	 *     subject = The subject to revoke authorizations from, typically a #PolkitUnixSession.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %TRUE if the temporary authorization was revoked, %FALSE if error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool revokeTemporaryAuthorizationsSync(SubjectIF subject, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_revoke_temporary_authorizations_sync(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Asynchronously unregisters an authentication agent.
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_authority_unregister_authentication_agent_finish() to get
	 * the result of the operation.
	 *
	 * Params:
	 *     subject = The subject the authentication agent is for, typically a #PolkitUnixSession object.
	 *     objectPath = The object path for the authentication agent.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public void unregisterAuthenticationAgent(SubjectIF subject, string objectPath, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_authority_unregister_authentication_agent(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(objectPath), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes unregistering an authentication agent.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the callback.
	 *
	 * Returns: %TRUE if the authentication agent was successfully unregistered, %FALSE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool unregisterAuthenticationAgentFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_authority_unregister_authentication_agent_finish(polkitAuthority, (res is null) ? null : res.getAsyncResultStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Unregisters an authentication agent. The calling thread is blocked
	 * until a reply is received. See
	 * polkit_authority_unregister_authentication_agent() for the
	 * asynchronous version.
	 *
	 * Params:
	 *     subject = The subject the authentication agent is for, typically a #PolkitUnixSession object.
	 *     objectPath = The object path for the authentication agent.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %TRUE if the authentication agent was successfully unregistered, %FALSE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool unregisterAuthenticationAgentSync(SubjectIF subject, string objectPath, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_authority_unregister_authentication_agent_sync(polkitAuthority, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(objectPath), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Emitted when actions and/or authorizations change
	 */
	gulong addOnChanged(void delegate(Authority) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "changed", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}
}
