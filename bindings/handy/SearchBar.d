module handy.SearchBar;

private import gdk.Event;
private import glib.ConstructionException;
private import gobject.ObjectG;
private import gtk.Bin;
private import gtk.BuildableIF;
private import gtk.BuildableT;
private import gtk.Entry;
private import gtk.Widget;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class SearchBar : Bin
{
	/** the main Gtk struct */
	protected HdySearchBar* hdySearchBar;

	/** Get the main Gtk struct */
	public HdySearchBar* getSearchBarStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdySearchBar;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdySearchBar;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdySearchBar* hdySearchBar, bool ownedRef = false)
	{
		this.hdySearchBar = hdySearchBar;
		super(cast(GtkBin*)hdySearchBar, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_search_bar_get_type();
	}

	/**
	 * Creates a #HdySearchBar. You will need to tell it about
	 * which widget is going to be your text entry using
	 * hdy_search_bar_connect_entry().
	 *
	 * Returns: a new #HdySearchBar
	 *
	 * Since: 0.0.6
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto p = hdy_search_bar_new();

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdySearchBar*) p);
	}

	/**
	 * Connects the #GtkEntry widget passed as the one to be used in
	 * this search bar. The entry should be a descendant of the search bar.
	 * This is only required if the entry isn’t the direct child of the
	 * search bar (as in our main example).
	 *
	 * Params:
	 *     entry = a #GtkEntry
	 *
	 * Since: 0.0.6
	 */
	public void connectEntry(Entry entry)
	{
		hdy_search_bar_connect_entry(hdySearchBar, (entry is null) ? null : entry.getEntryStruct());
	}

	/**
	 * Returns whether the search mode is on or off.
	 *
	 * Returns: whether search mode is toggled on
	 *
	 * Since: 0.0.6
	 */
	public bool getSearchMode()
	{
		return hdy_search_bar_get_search_mode(hdySearchBar) != 0;
	}

	/**
	 * Returns whether the close button is shown.
	 *
	 * Returns: whether the close button is shown
	 *
	 * Since: 0.0.6
	 */
	public bool getShowCloseButton()
	{
		return hdy_search_bar_get_show_close_button(hdySearchBar) != 0;
	}

	/**
	 * This function should be called when the top-level
	 * window which contains the search bar received a key event.
	 *
	 * If the key event is handled by the search bar, the bar will
	 * be shown, the entry populated with the entered text and %GDK_EVENT_STOP
	 * will be returned. The caller should ensure that events are
	 * not propagated further.
	 *
	 * If no entry has been connected to the search bar, using
	 * hdy_search_bar_connect_entry(), this function will return
	 * immediately with a warning.
	 *
	 * ## Showing the search bar on key presses
	 *
	 * |[<!-- language="C" -->
	 * static gboolean
	 * on_key_press_event (GtkWidget *widget,
	 * GdkEvent  *event,
	 * gpointer   user_data)
	 * {
	 * HdySearchBar *bar = HDY_SEARCH_BAR (user_data);
	 * return hdy_search_bar_handle_event (self, event);
	 * }
	 *
	 * static void
	 * create_toplevel (void)
	 * {
	 * GtkWidget *window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
	 * GtkWindow *search_bar = hdy_search_bar_new ();
	 *
	 * // Add more widgets to the window...
	 *
	 * g_signal_connect (window,
	 * "key-press-event",
	 * G_CALLBACK (on_key_press_event),
	 * search_bar);
	 * }
	 * ]|
	 *
	 * Params:
	 *     event = a #GdkEvent containing key press events
	 *
	 * Returns: %GDK_EVENT_STOP if the key press event resulted
	 *     in text being entered in the search entry (and revealing
	 *     the search bar if necessary), %GDK_EVENT_PROPAGATE otherwise.
	 *
	 * Since: 0.0.6
	 */
	public bool handleEvent(Event event)
	{
		return hdy_search_bar_handle_event(hdySearchBar, (event is null) ? null : event.getEventStruct()) != 0;
	}

	/**
	 * Switches the search mode on or off.
	 *
	 * Params:
	 *     searchMode = the new state of the search mode
	 *
	 * Since: 0.0.6
	 */
	public void setSearchMode(bool searchMode)
	{
		hdy_search_bar_set_search_mode(hdySearchBar, searchMode);
	}

	/**
	 * Shows or hides the close button. Applications that
	 * already have a “search” toggle button should not show a close
	 * button in their search bar, as it duplicates the role of the
	 * toggle button.
	 *
	 * Params:
	 *     visible = whether the close button will be shown or not
	 *
	 * Since: 0.0.6
	 */
	public void setShowCloseButton(bool visible)
	{
		hdy_search_bar_set_show_close_button(hdySearchBar, visible);
	}
}
