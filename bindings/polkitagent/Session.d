module polkitagent.Session;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import gobject.Signals;
private import polkit.IdentityIF;
private import polkitagent.c.functions;
public  import polkitagent.c.types;
private import std.algorithm;


/**
 * The #PolkitAgentSession class is an abstraction used for interacting with the
 * native authentication system (for example PAM) for obtaining authorizations.
 * This class is typically used together with instances that are derived from
 * the #PolkitAgentListener abstract base class.
 * 
 * To perform the actual authentication, #PolkitAgentSession uses a trusted suid helper.
 * The authentication conversation is done through a pipe. This is transparent; the user
 * only need to handle the
 * #PolkitAgentSession::request,
 * #PolkitAgentSession::show-info,
 * #PolkitAgentSession::show-error and
 * #PolkitAgentSession::completed
 * signals and invoke polkit_agent_session_response() in response to requests.
 * 
 * If the user successfully authenticates, the authentication helper will invoke
 * a method on the PolicyKit daemon (see polkit_authority_authentication_agent_response_sync())
 * with the given @cookie. Upon receiving a positive response from the PolicyKit daemon (via
 * the authentication helper), the #PolkitAgentSession::completed signal will be emitted
 * with the @gained_authorization paramter set to %TRUE.
 * 
 * If the user is unable to authenticate, the #PolkitAgentSession::completed signal will
 * be emitted with the @gained_authorization paramter set to %FALSE.
 */
public class Session : ObjectG
{
	/** the main Gtk struct */
	protected PolkitAgentSession* polkitAgentSession;

	/** Get the main Gtk struct */
	public PolkitAgentSession* getSessionStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitAgentSession;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitAgentSession;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitAgentSession* polkitAgentSession, bool ownedRef = false)
	{
		this.polkitAgentSession = polkitAgentSession;
		super(cast(GObject*)polkitAgentSession, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return polkit_agent_session_get_type();
	}

	/**
	 * Creates a new authentication session.
	 *
	 * The caller should connect to the
	 * #PolkitAgentSession::request,
	 * #PolkitAgentSession::show-info,
	 * #PolkitAgentSession::show-error and
	 * #PolkitAgentSession::completed
	 * signals and then call polkit_agent_session_initiate() to initiate the authentication session.
	 *
	 * Params:
	 *     identity = The identity to authenticate.
	 *     cookie = The cookie obtained from the PolicyKit daemon
	 *
	 * Returns: A #PolkitAgentSession. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(IdentityIF identity, string cookie)
	{
		auto p = polkit_agent_session_new((identity is null) ? null : identity.getIdentityStruct(), Str.toStringz(cookie));

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitAgentSession*) p, true);
	}

	/**
	 * Cancels an authentication session. This will make @session emit the #PolkitAgentSession::completed
	 * signal.
	 */
	public void cancel()
	{
		polkit_agent_session_cancel(polkitAgentSession);
	}

	/**
	 * Initiates the authentication session. Before calling this method,
	 * make sure to connect to the various signals. The signals will be
	 * emitted in the <link
	 * linkend="g-main-context-push-thread-default">thread-default main
	 * loop</link> that this method is invoked from.
	 *
	 * Use polkit_agent_session_cancel() to cancel the session.
	 */
	public void initiate()
	{
		polkit_agent_session_initiate(polkitAgentSession);
	}

	/**
	 * Function for providing response to requests received
	 * via the #PolkitAgentSession::request signal.
	 *
	 * Params:
	 *     response = Response from the user, typically a password.
	 */
	public void response(string response)
	{
		polkit_agent_session_response(polkitAgentSession, Str.toStringz(response));
	}

	/**
	 * Emitted when the authentication session has been completed or
	 * cancelled. The @gained_authorization parameter is %TRUE only if
	 * the user successfully authenticated.
	 *
	 * Upon receiving this signal, the user should free @session using g_object_unref().
	 *
	 * Params:
	 *     gainedAuthorization = %TRUE only if the authorization was successfully obtained.
	 */
	gulong addOnCompleted(void delegate(bool, Session) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "completed", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}

	/**
	 * Emitted when the user is requested to answer a question.
	 *
	 * When the response has been collected from the user, call polkit_agent_session_response().
	 *
	 * Params:
	 *     request = The request to show the user, e.g. "name: " or "password: ".
	 *     echoOn = %TRUE if the response to the request SHOULD be echoed on the
	 *         screen, %FALSE if the response MUST NOT be echoed to the screen.
	 */
	gulong addOnRequest(void delegate(string, bool, Session) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "request", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}

	/**
	 * Emitted when there is information related to an error condition to be displayed to the user.
	 *
	 * Params:
	 *     text = An error string to display to the user.
	 */
	gulong addOnShowError(void delegate(string, Session) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "show-error", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}

	/**
	 * Emitted when there is information to be displayed to the user.
	 *
	 * Params:
	 *     text = A string to display to the user.
	 */
	gulong addOnShowInfo(void delegate(string, Session) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "show-info", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}
}
