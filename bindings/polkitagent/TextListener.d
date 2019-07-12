module polkitagent.TextListener;

private import gio.Cancellable;
private import gio.InitableIF;
private import gio.InitableT;
private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import gobject.ObjectG;
private import polkitagent.Listener;
private import polkitagent.c.functions;
public  import polkitagent.c.types;


/**
 * #PolkitAgentTextListener is an #PolkitAgentListener implementation
 * that interacts with the user using a textual interface.
 */
public class TextListener : Listener, InitableIF
{
	/** the main Gtk struct */
	protected PolkitAgentTextListener* polkitAgentTextListener;

	/** Get the main Gtk struct */
	public PolkitAgentTextListener* getTextListenerStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitAgentTextListener;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitAgentTextListener;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitAgentTextListener* polkitAgentTextListener, bool ownedRef = false)
	{
		this.polkitAgentTextListener = polkitAgentTextListener;
		super(cast(PolkitAgentListener*)polkitAgentTextListener, ownedRef);
	}

	// add the Initable capabilities
	mixin InitableT!(PolkitAgentTextListener);


	/** */
	public static GType getType()
	{
		return polkit_agent_text_listener_get_type();
	}

	/**
	 * Creates a new #PolkitAgentTextListener for authenticating the user
	 * via an textual interface on the controlling terminal
	 * (e.g. <filename>/dev/tty</filename>). This can fail if e.g. the
	 * current process has no controlling terminal.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A #PolkitAgentTextListener or %NULL if @error is set. Free with g_object_unref() when done with it.
	 *
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_agent_text_listener_new((cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitAgentTextListener*) p, true);
	}
}
