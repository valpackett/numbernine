module handy.Dialog;

private import glib.ConstructionException;
private import gobject.ObjectG;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.Dialog : GtkDialog = Dialog;
private import gtk.Widget;
private import gtk.Window;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class Dialog : GtkDialog
{
	/** the main Gtk struct */
	protected HdyDialog* hdyDialog;

	/** Get the main Gtk struct */
	public HdyDialog* getHandyDialogStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyDialog;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyDialog;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyDialog* hdyDialog, bool ownedRef = false)
	{
		this.hdyDialog = hdyDialog;
		super(cast(GtkDialog*)hdyDialog, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_dialog_get_type();
	}

	/**
	 * Create a #HdyDialog with #GtkWindow:transient-for set to parent
	 *
	 * C Usage
	 * |[<!-- language="C" -->
	 * GtkWidget *dlg = hdy_dialog_new (GTK_WINDOW (main_window));
	 * ]|
	 *
	 * Vala Usage
	 * |[<!-- language="Vala" -->
	 * var dlg = new Hdy.Dialog (main_window);
	 * ]|
	 *
	 * Python Usage
	 * |[<!-- language="Python" -->
	 * dlg = Handy.Dialog.new (main_window);
	 * ]|
	 *
	 * Params:
	 *     parent = #GtkWindow this dialog is a child of
	 *
	 * Since: 0.0.7
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(Window parent)
	{
		auto p = hdy_dialog_new((parent is null) ? null : parent.getWindowStruct());

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyDialog*) p);
	}
}
