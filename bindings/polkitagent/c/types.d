module polkitagent.c.types;

public import gio.c.types;
public import glib.c.types;
public import gobject.c.types;
public import polkit.c.types;


/**
 * Flags used in polkit_agent_listener_register().
 */
public enum PolkitAgentRegisterFlags
{
	/**
	 * No flags are set.
	 */
	NONE = 0,
	/**
	 * Run the listener in a dedicated thread.
	 */
	RUN_IN_THREAD = 1,
}
alias PolkitAgentRegisterFlags RegisterFlags;

struct PolkitAgentListener
{
	GObject parentInstance;
}

/**
 * VFuncs that authentication agents needs to implement.
 */
struct PolkitAgentListenerClass
{
	/**
	 * The parent class.
	 */
	GObjectClass parentClass;
	/** */
	extern(C) void function(PolkitAgentListener* listener, const(char)* actionId, const(char)* message, const(char)* iconName, PolkitDetails* details, const(char)* cookie, GList* identities, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData) initiateAuthentication;
	/**
	 *
	 * Params:
	 *     listener = A #PolkitAgentListener.
	 *     res = A #GAsyncResult obtained from the #GAsyncReadyCallback function passed to polkit_agent_listener_initiate_authentication().
	 * Returns: %TRUE if @error is set.
	 *
	 * Throws: GException on failure.
	 */
	extern(C) int function(PolkitAgentListener* listener, GAsyncResult* res, GError** err) initiateAuthenticationFinish;
	/** */
	extern(C) void function() PolkitReserved0;
	/** */
	extern(C) void function() PolkitReserved1;
	/** */
	extern(C) void function() PolkitReserved2;
	/** */
	extern(C) void function() PolkitReserved3;
	/** */
	extern(C) void function() PolkitReserved4;
	/** */
	extern(C) void function() PolkitReserved5;
	/** */
	extern(C) void function() PolkitReserved6;
	/** */
	extern(C) void function() PolkitReserved7;
}

struct PolkitAgentSession;

struct PolkitAgentSessionClass;

struct PolkitAgentTextListener;
