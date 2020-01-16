module handy.DialerButton;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import gtk.ActionableIF;
private import gtk.ActionableT;
private import gtk.ActivatableIF;
private import gtk.ActivatableT;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.Button;
private import gtk.Widget;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class DialerButton : Button
{
	/** the main Gtk struct */
	protected HdyDialerButton* hdyDialerButton;

	/** Get the main Gtk struct */
	public HdyDialerButton* getDialerButtonStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyDialerButton;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyDialerButton;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyDialerButton* hdyDialerButton, bool ownedRef = false)
	{
		this.hdyDialerButton = hdyDialerButton;
		super(cast(GtkButton*)hdyDialerButton, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_dialer_button_get_type();
	}

	/**
	 * Create a new #HdyDialerButton which displays
	 * @symbols. If
	 * @symbols is %NULL no symbols will be displayed.
	 *
	 * Params:
	 *     symbols = the symbols displayed on the #HdyDialerButton
	 *
	 * Returns: the newly created #HdyDialerButton widget
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(string symbols)
	{
		auto __p = hdy_dialer_button_new(Str.toStringz(symbols));

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyDialerButton*) __p);
	}

	/**
	 * Get the #HdyDialerButton's digit.
	 *
	 * Returns: the button's digit
	 */
	public int getDigit()
	{
		return hdy_dialer_button_get_digit(hdyDialerButton);
	}

	/**
	 * Get the #HdyDialerButton's symbols.
	 *
	 * Returns: the button's symbols.
	 */
	public string getSymbols()
	{
		return Str.toString(hdy_dialer_button_get_symbols(hdyDialerButton));
	}
}
