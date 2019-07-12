module polkit.Permission;

private import gio.AsyncInitableIF;
private import gio.AsyncInitableT;
private import gio.AsyncResultIF;
private import gio.Cancellable;
private import gio.InitableIF;
private import gio.InitableT;
private import gio.Permission : GioPermission = Permission;
private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import glib.Str;
private import gobject.ObjectG;
private import polkit.SubjectIF;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * #PolkitPermission is a #GPermission implementation. It can be used
 * with e.g. #GtkLockButton. See the #GPermission documentation for
 * more information.
 */
public class Permission : GioPermission, AsyncInitableIF, InitableIF
{
	/** the main Gtk struct */
	protected PolkitPermission* polkitPermission;

	/** Get the main Gtk struct */
	public PolkitPermission* getPolkitPermissionStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitPermission;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitPermission;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitPermission* polkitPermission, bool ownedRef = false)
	{
		this.polkitPermission = polkitPermission;
		super(cast(GPermission*)polkitPermission, ownedRef);
	}

	// add the AsyncInitable capabilities
	mixin AsyncInitableT!(PolkitPermission);

	// add the Initable capabilities
	mixin InitableT!(PolkitPermission);


	/** */
	public static GType getType()
	{
		return polkit_permission_get_type();
	}

	/**
	 * Finishes an operation started with polkit_permission_new().
	 *
	 * Params:
	 *     res = A #GAsyncResult obtained from the #GAsyncReadyCallback passed to polkit_permission_new().
	 *
	 * Returns: A #GPermission or %NULL if @error is set.
	 *
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(AsyncResultIF res)
	{
		GError* err = null;

		auto p = polkit_permission_new_finish((res is null) ? null : res.getAsyncResultStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			throw new ConstructionException("null returned by new_finish");
		}

		this(cast(PolkitPermission*) p, true);
	}

	/**
	 * Creates a #GPermission instance for the PolicyKit action
	 * @action_id.
	 *
	 * This is a synchronous failable constructor. See
	 * polkit_permission_new() for the asynchronous version.
	 *
	 * Params:
	 *     actionId = The PolicyKit action identifier.
	 *     subject = A #PolkitSubject or %NULL for the current process.
	 *     cancellable = A #GCancellable or %NULL.
	 *
	 * Returns: A #GPermission or %NULL if @error is set.
	 *
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(string actionId, SubjectIF subject, Cancellable cancellable)
	{
		GError* err = null;

		auto p = polkit_permission_new_sync(Str.toStringz(actionId), (subject is null) ? null : subject.getSubjectStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		if(p is null)
		{
			throw new ConstructionException("null returned by new_sync");
		}

		this(cast(PolkitPermission*) p, true);
	}

	/**
	 * Creates a #GPermission instance for the PolicyKit action
	 * @action_id.
	 *
	 * When the operation is finished, @callback will be invoked. You can
	 * then call polkit_permission_new_finish() to get the result of the
	 * operation.
	 *
	 * This is a asynchronous failable constructor. See
	 * polkit_permission_new_sync() for the synchronous version.
	 *
	 * Params:
	 *     actionId = The PolicyKit action identifier.
	 *     subject = A #PolkitSubject or %NULL for the current process.
	 *     cancellable = A #GCancellable or %NULL.
	 *     callback = A #GAsyncReadyCallback to call when the request is satisfied.
	 *     userData = The data to pass to @callback.
	 */
	public static void new(string actionId, SubjectIF subject, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		polkit_permission_new(Str.toStringz(actionId), (subject is null) ? null : subject.getSubjectStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}

	/**
	 * Gets the PolicyKit action identifier used for @permission.
	 *
	 * Returns: A string owned by @permission. Do not free.
	 */
	public string getActionId()
	{
		return Str.toString(polkit_permission_get_action_id(polkitPermission));
	}

	/**
	 * Gets the subject used for @permission.
	 *
	 * Returns: An object owned by @permission. Do not free.
	 */
	public SubjectIF getSubject()
	{
		auto p = polkit_permission_get_subject(polkitPermission);

		if(p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(SubjectIF)(cast(PolkitSubject*) p);
	}
}
