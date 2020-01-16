module handy.Dialer;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import gobject.Signals;
private import gtk.Bin;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.Widget;
private import handy.c.functions;
public  import handy.c.types;
private import std.algorithm;


/** */
public class Dialer : Bin
{
	/** the main Gtk struct */
	protected HdyDialer* hdyDialer;

	/** Get the main Gtk struct */
	public HdyDialer* getDialerStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyDialer;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyDialer;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyDialer* hdyDialer, bool ownedRef = false)
	{
		this.hdyDialer = hdyDialer;
		super(cast(GtkBin*)hdyDialer, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_dialer_get_type();
	}

	/**
	 * Create a new #HdyDialer widget.
	 *
	 * Returns: the newly created #HdyDialer widget
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto __p = hdy_dialer_new();

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyDialer*) __p);
	}

	/**
	 * Set the current number to the empty string. When the number is already
	 * cleared no action is performed.
	 */
	public void clearNumber()
	{
		hdy_dialer_clear_number(hdyDialer);
	}

	/**
	 * Get the currently displayed number.
	 *
	 * Returns: the current number in the display
	 */
	public string getNumber()
	{
		return Str.toString(hdy_dialer_get_number(hdyDialer));
	}

	/**
	 * Returns the current relief style of the main buttons for the given
	 * #HdyDialer.
	 *
	 * Returns: The current #GtkReliefStyle
	 */
	public GtkReliefStyle getRelief()
	{
		return hdy_dialer_get_relief(hdyDialer);
	}

	/**
	 * Get whether the submit and delete buttons are to be shown.
	 *
	 * Returns: whether the buttons are to be shown
	 */
	public bool getShowActionButtons()
	{
		return hdy_dialer_get_show_action_buttons(hdyDialer) != 0;
	}

	/**
	 * Set the currently displayed number.
	 *
	 * Params:
	 *     number = the number to set
	 */
	public void setNumber(string number)
	{
		hdy_dialer_set_number(hdyDialer, Str.toStringz(number));
	}

	/**
	 * Sets the relief style of the edges of the main buttons for the given
	 * #HdyDialer widget.
	 * Two styles exist, %GTK_RELIEF_NORMAL and %GTK_RELIEF_NONE.
	 * The default style is, as one can guess, %GTK_RELIEF_NORMAL.
	 *
	 * Params:
	 *     relief = The #GtkReliefStyle as described above
	 */
	public void setRelief(GtkReliefStyle relief)
	{
		hdy_dialer_set_relief(hdyDialer, relief);
	}

	/**
	 * Set whether to show the submit and delete buttons.
	 *
	 * Params:
	 *     show = whether to show the buttons
	 */
	public void setShowActionButtons(bool show)
	{
		hdy_dialer_set_show_action_buttons(hdyDialer, show);
	}

	/**
	 * This signal is emitted when the dialer's 'deleted' button is clicked
	 * to delete the last symbol.
	 */
	gulong addOnDeleted(void delegate(Dialer) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "deleted", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}

	/**
	 * This signal is emitted when the dialer's 'dial' button is activated.
	 * Connect to this signal to perform to get notified when the user
	 * wants to submit the dialed number.
	 *
	 * Params:
	 *     number = The number at the time of activation.
	 */
	gulong addOnSubmitted(void delegate(string, Dialer) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "submitted", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}

	/**
	 * This signal is emitted when one of the symbol buttons (0-9, # or *)
	 * is clicked. Connect to this signal to find out which button was pressed.
	 * This doesn't take any cycling modes into account. So the button with "*"
	 * and "+" on it will always send "*".  Delete and Submit buttons will
	 * not trigger this signal.
	 *
	 * Params:
	 *     button = The main symbol on the button that was clicked
	 */
	gulong addOnSymbolClicked(void delegate(char, Dialer) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		return Signals.connect(this, "symbol-clicked", dlg, connectFlags ^ ConnectFlags.SWAPPED);
	}
}
