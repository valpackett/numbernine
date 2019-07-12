module polkit.SubjectT;

public  import gio.AsyncResultIF;
public  import gio.Cancellable;
public  import glib.ErrorG;
public  import glib.GException;
public  import glib.Str;
public  import gobject.ObjectG;
public  import polkit.SubjectIF;
public  import polkit.c.functions;
public  import polkit.c.types;


/**
 * #PolkitSubject is an abstract type for representing one or more
 * processes.
 */
public template SubjectT(TStruct)
{
	/** Get the main Gtk struct */
	public PolkitSubject* getSubjectStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return cast(PolkitSubject*)getStruct();
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
	public bool equal(SubjectIF b)
	{
		return polkit_subject_equal(getSubjectStruct(), (b is null) ? null : b.getSubjectStruct()) != 0;
	}

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
	public void exists(Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_subject_exists(getSubjectStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

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
	public bool existsFinish(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_subject_exists_finish(getSubjectStruct(), (res is null) ? null : res.getAsyncResultStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

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
	public bool existsSync(Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_subject_exists_sync(getSubjectStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err) != 0;

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Gets a hash code for @subject that can be used with e.g. g_hash_table_new().
	 *
	 * Returns: A hash code.
	 */
	public uint hash()
	{
		return polkit_subject_hash(getSubjectStruct());
	}

	/**
	 * Serializes @subject to a string that can be used in
	 * polkit_subject_from_string().
	 *
	 * Returns: A string representing @subject. Free with g_free().
	 */
	public override string toString()
	{
		auto retStr = polkit_subject_to_string(getSubjectStruct());

		scope(exit) Str.freeString(retStr);
		return Str.toString(retStr);
	}
}
