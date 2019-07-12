module polkit.UnixSession;

private import gio.AsyncInitableIF;
private import gio.AsyncInitableT;
private import gio.AsyncResultIF;
private import gio.Cancellable;
private import gio.InitableIF;
private import gio.InitableT;
private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.SubjectIF;
private import polkit.SubjectT;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * An object that represents an user session.
 * 
 * The session id is an opaque string obtained from ConsoleKit.
 */
public class UnixSession : ObjectG, AsyncInitableIF, InitableIF, SubjectIF
{
	/** the main Gtk struct */
	protected PolkitUnixSession* polkitUnixSession;

	/** Get the main Gtk struct */
	public PolkitUnixSession* getUnixSessionStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitUnixSession;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitUnixSession;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitUnixSession* polkitUnixSession, bool ownedRef = false)
	{
		this.polkitUnixSession = polkitUnixSession;
		super(cast(GObject*)polkitUnixSession, ownedRef);
	}

	// add the AsyncInitable capabilities
	mixin AsyncInitableT!(PolkitUnixSession);

	// add the Initable capabilities
	mixin InitableT!(PolkitUnixSession);

	// add the Subject capabilities
	mixin SubjectT!(PolkitUnixSession);


	/** */
	public static GType getType()
	{
		return polkit_unix_session_get_type();
	}

	/**
	 * Creates a new #PolkitUnixSession for @session_id.
	 *
	 * Params:
	 *     sessionId = The session id.
	 *
	 * Returns: A #PolkitUnixSession. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(string sessionId)
	{
		auto p = polkit_unix_session_new(Str.toStringz(sessionId));

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitUnixSession*) p, true);
	}

	/**
	 * Asynchronously creates a new #PolkitUnixSession object for the
	 * process with process id @pid.
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call
	 * polkit_unix_session_new_for_process_finish() to get the result of
	 * the operation.
	 *
	 * This method constructs the object asynchronously, for the synchronous and blocking version
	 * use polkit_unix_session_new_for_process_sync().
	 *
	 * Params:
	 *     pid = The process id of the process to get the session for.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied
	 *     userData = The data to pass to @callback.
	 */
	public static void newForProcess(int pid, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_unix_session_new_for_process(pid, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Finishes constructing a #PolkitSubject for a process id.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the #GAsyncReadyCallback passed to polkit_unix_session_new_for_process().
	 *
	 * Returns: A #PolkitUnixSession for the @pid passed to
	 *     polkit_unix_session_new_for_process() or %NULL if @error is
	 *     set. Free with g_object_unref().
	 *
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_unix_session_new_for_process_finish((res is null) ? null : res.getAsyncResultStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			throw new ConstructionException("null returned by new_for_process_finish");
		}

		this(cast(PolkitUnixSession*) p, true);
	}

	/**
	 * Creates a new #PolkitUnixSession for the process with process id @pid.
	 *
	 * This is a synchronous call - the calling thread is blocked until a
	 * reply is received. For the asynchronous version, see
	 * polkit_unix_session_new_for_process().
	 *
	 * Params:
	 *     pid = The process id of the process to get the session for.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A #PolkitUnixSession for
	 *     @pid or %NULL if @error is set. Free with g_object_unref().
	 *
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(int pid, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_unix_session_new_for_process_sync(pid, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			throw new ConstructionException("null returned by new_for_process_sync");
		}

		this(cast(PolkitUnixSession*) p, true);
	}

	/**
	 * Gets the session id for @session.
	 *
	 * Returns: The session id for @session. Do not free this string, it
	 *     is owned by @session.
	 */
	public string getSessionId()
	{
		return Str.toString(polkit_unix_session_get_session_id(polkitUnixSession));
	}

	/**
	 * Sets the session id for @session to @session_id.
	 *
	 * Params:
	 *     sessionId = The session id.
	 */
	public void setSessionId(string sessionId)
	{
		polkit_unix_session_set_session_id(polkitUnixSession, Str.toStringz(sessionId));
	}
}
