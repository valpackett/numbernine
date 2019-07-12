module polkitagent.Listener;

private import gio.AsyncResultIF;
private import gio.Cancellable;
private import glib.ErrorG;
private import glib.GException;
private import glib.ListG;
private import glib.Str;
private import glib.Variant;
private import gobject.ObjectG;
private import polkit.Details;
private import polkit.IdentityIF;
private import polkit.SubjectIF;
private import polkitagent.c.functions;
public  import polkitagent.c.types;


/**
 * #PolkitAgentListener is an abstract base class used for implementing authentication
 * agents. To implement an authentication agent, simply subclass #PolkitAgentListener and
 * implement the @initiate_authentication and @initiate_authentication_finish methods.
 * 
 * Typically authentication agents use #PolkitAgentSession to
 * authenticate users (via passwords) and communicate back the
 * authentication result to the PolicyKit daemon.
 * 
 * To register a #PolkitAgentListener with the PolicyKit daemon, use
 * polkit_agent_listener_register() or
 * polkit_agent_listener_register_with_options().
 */
public class Listener : ObjectG
{
	/** the main Gtk struct */
	protected PolkitAgentListener* polkitAgentListener;

	/** Get the main Gtk struct */
	public PolkitAgentListener* getListenerStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitAgentListener;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitAgentListener;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitAgentListener* polkitAgentListener, bool ownedRef = false)
	{
		this.polkitAgentListener = polkitAgentListener;
		super(cast(GObject*)polkitAgentListener, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return polkit_agent_listener_get_type();
	}

	/**
	 * Unregisters @listener.
	 *
	 * Params:
	 *     registrationHandle = A handle obtained from polkit_agent_listener_register().
	 */
	public static void unregister(void* registrationHandle)
	{
		polkit_agent_listener_unregister(registrationHandle);
	}

	/**
	 * Called on a registered authentication agent (see
	 * polkit_agent_listener_register()) when the user owning the session
	 * needs to prove he is one of the identities listed in @identities.
	 *
	 * When the user is done authenticating (for example by dismissing an
	 * authentication dialog or by successfully entering a password or
	 * otherwise proving the user is one of the identities in
	 * @identities), @callback will be invoked. The caller then calls
	 * polkit_agent_listener_initiate_authentication_finish() to get the
	 * result.
	 *
	 * #PolkitAgentListener derived subclasses imlementing this method
	 * <emphasis>MUST</emphasis> not ignore @cancellable; callers of this
	 * function can and will use it. Additionally, @callback must be
	 * invoked in the <link
	 * linkend="g-main-context-push-thread-default">thread-default main
	 * loop</link> of the thread that this method is called from.
	 *
	 * Params:
	 *     actionId = The action to authenticate for.
	 *     message = The message to present to the user.
	 *     iconName = A themed icon name representing the action or %NULL.
	 *     details = Details describing the action.
	 *     cookie = The cookie for the authentication request.
	 *     identities = A list of #PolkitIdentity objects that the user can choose to authenticate as.
	 *     cancellable = A #GCancellable.
	 *     callback = Function to call when the user is done authenticating.
	 *     userData = Data to pass to @callback.
	 */
	public void initiateAuthentication(string actionId, string message, string iconName, Details details, string cookie, ListG identities, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_agent_listener_initiate_authentication(polkitAgentListener, Str.toStringz(actionId), Str.toStringz(message), Str.toStringz(iconName), (details is null) ? null : details.getDetailsStruct(), Str.toStringz(cookie), (identities is null) ? null : identities.getListGStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes an authentication request from the PolicyKit daemon, see
	 * polkit_agent_listener_initiate_authentication() for details.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the #GAsyncReadyCallback function passed to polkit_agent_listener_initiate_authentication().
	 *
	 * Returns: %TRUE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool initiateAuthenticationFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_agent_listener_initiate_authentication_finish(polkitAgentListener, (res is null) ? null : res.getAsyncResultStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Registers @listener with the PolicyKit daemon as an authentication
	 * agent for @subject. This is implemented by registering a D-Bus
	 * object at @object_path on the unique name assigned by the system
	 * message bus.
	 *
	 * Whenever the PolicyKit daemon needs to authenticate a processes
	 * that is related to @subject, the methods
	 * polkit_agent_listener_initiate_authentication() and
	 * polkit_agent_listener_initiate_authentication_finish() will be
	 * invoked on @listener.
	 *
	 * Note that registration of an authentication agent can fail; for
	 * example another authentication agent may already be registered for
	 * @subject.
	 *
	 * Note that the calling thread is blocked until a reply is received.
	 *
	 * Params:
	 *     flags = A set of flags from the #PolkitAgentRegisterFlags enumeration.
	 *     subject = The subject to become an authentication agent for, typically a #PolkitUnixSession object.
	 *     objectPath = The D-Bus object path to use for the authentication agent or %NULL for the default object path.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %NULL if @error is set, otherwise a
	 *     registration handle that can be used with
	 *     polkit_agent_listener_unregister().
	 *
	 * Throws: GException on failure.
	 */
	public void* register(PolkitAgentRegisterFlags flags, SubjectIF subject, string objectPath, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_agent_listener_register(polkitAgentListener, flags, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(objectPath), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Like polkit_agent_listener_register() but takes options to influence registration. See the
	 * <link linkend="eggdbus-method-org.freedesktop.PolicyKit1.Authority.RegisterAuthenticationAgentWithOptions">RegisterAuthenticationAgentWithOptions()</link> D-Bus method for details.
	 *
	 * Params:
	 *     flags = A set of flags from the #PolkitAgentRegisterFlags enumeration.
	 *     subject = The subject to become an authentication agent for, typically a #PolkitUnixSession object.
	 *     objectPath = The D-Bus object path to use for the authentication agent or %NULL for the default object path.
	 *     options = A #GVariant with options or %NULL.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %NULL if @error is set, otherwise a
	 *     registration handle that can be used with
	 *     polkit_agent_listener_unregister().
	 *
	 * Throws: GException on failure.
	 */
	public void* registerWithOptions(PolkitAgentRegisterFlags flags, SubjectIF subject, string objectPath, Variant options, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_agent_listener_register_with_options(polkitAgentListener, flags, (subject is null) ? null : subject.getSubjectStruct(), Str.toStringz(objectPath), (options is null) ? null : options.getVariantStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}
}
