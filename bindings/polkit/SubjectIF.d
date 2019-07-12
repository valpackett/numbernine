module polkit.SubjectIF;

private import gio.AsyncResultIF;
private import gio.Cancellable;
private import glib.ErrorG;
private import glib.GException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.SubjectIF;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * #PolkitSubject is an abstract type for representing one or more
 * processes.
 */
public interface SubjectIF{
	/** Get the main Gtk struct */
	public PolkitSubject* getSubjectStruct(bool transferOwnership = false);

	/** the main Gtk struct as a void* */
	protected void* getStruct();


	/** */
	public static GType getType()
	{
		return polkit_subject_get_type();
	}

	/**
	 * Creates an object from @str that implements the #PolkitSubject
	 * interface.
	 *
	 * Params:
	 *     str = A string obtained from polkit_subject_to_string().
	 *
	 * Returns: A #PolkitSubject or %NULL if @error is
	 *     set. Free with g_object_unref().
	 *
	 * Throws: GException on failure.
	 */
	public static SubjectIF fromString(string str)
	{
		GError* err = null;

		auto p = polkit_subject_from_string(Str.toStringz(str), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(SubjectIF)(cast(PolkitSubject*) p, true);
	}

	/**
	 * Checks if @a and @b are equal, ie. represent the same subject.
	 *
	 * This function can be used in e.g. g_hash_table_new().
	 *
	 * Params:
	 *     b = A #PolkitSubject.
	 *
	 * Returns: %TRUE if @a and @b are equal, %FALSE otherwise.
	 */
	public bool equal(SubjectIF b);

	/**
	 * Asynchronously checks if @subject exists.
	 *
	 * When the operation is finished, @callback will be invoked in the
	 * <link linkend="g-main-context-push-thread-default">thread-default
	 * main loop</link> of the thread you are calling this method
	 * from. You can then call polkit_subject_exists_finish() to get the
	 * result of the operation.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied
	 *     userData = The data to pass to @callback.
	 */
	public void exists(Cancellable cancellable, GAsyncReadyCallback callback, void* userData);

	/**
	 * Finishes checking whether a subject exists.
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the #GAsyncReadyCallback passed to polkit_subject_exists().
	 *
	 * Returns: %TRUE if the subject exists, %FALSE if not or @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool existsFinish(AsyncResultIF res);

	/**
	 * Checks if @subject exists.
	 *
	 * This is a synchronous blocking call - the calling thread is blocked
	 * until a reply is received. See polkit_subject_exists() for the
	 * asynchronous version.
	 *
	 * Params:
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: %TRUE if the subject exists, %FALSE if not or @error is set.
	 *
	 * Throws: GException on failure.
	 */
	public bool existsSync(Cancellable cancellable);

	/**
	 * Gets a hash code for @subject that can be used with e.g. g_hash_table_new().
	 *
	 * Returns: A hash code.
	 */
	public uint hash();

	/**
	 * Serializes @subject to a string that can be used in
	 * polkit_subject_from_string().
	 *
	 * Returns: A string representing @subject. Free with g_free().
	 */
	public string toString();
}
