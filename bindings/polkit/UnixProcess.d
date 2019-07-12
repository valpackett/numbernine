module polkit.UnixProcess;

private import glib.ConstructionException;
private import glib.ErrorG;
private import glib.GException;
private import gobject.ObjectG;
private import polkit.SubjectIF;
private import polkit.SubjectT;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * An object for representing a UNIX process.
 * 
 * To uniquely identify processes, both the process id and the start
 * time of the process (a monotonic increasing value representing the
 * time since the kernel was started) is used.
 */
public class UnixProcess : ObjectG, SubjectIF
{
	/** the main Gtk struct */
	protected PolkitUnixProcess* polkitUnixProcess;

	/** Get the main Gtk struct */
	public PolkitUnixProcess* getUnixProcessStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitUnixProcess;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitUnixProcess;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitUnixProcess* polkitUnixProcess, bool ownedRef = false)
	{
		this.polkitUnixProcess = polkitUnixProcess;
		super(cast(GObject*)polkitUnixProcess, ownedRef);
	}

	// add the Subject capabilities
	mixin SubjectT!(PolkitUnixProcess);


	/** */
	public static GType getType()
	{
		return polkit_unix_process_get_type();
	}

	/**
	 * Creates a new #PolkitUnixProcess for @pid.
	 *
	 * The uid and start time of the process will be looked up in using
	 * e.g. the <filename>/proc</filename> filesystem depending on the
	 * platform in use.
	 *
	 * Params:
	 *     pid = The process id.
	 *
	 * Returns: A #PolkitSubject. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(int pid)
	{
		auto p = polkit_unix_process_new(pid);

		if(p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(PolkitUnixProcess*) p, true);
	}

	/**
	 * Creates a new #PolkitUnixProcess object for @pid, @start_time and @uid.
	 *
	 * Params:
	 *     pid = The process id.
	 *     startTime = The start time for @pid or 0 to look it up in e.g. <filename>/proc</filename>.
	 *     uid = The (real, not effective) uid of the owner of @pid or -1 to look it up in e.g. <filename>/proc</filename>.
	 *
	 * Returns: A #PolkitSubject. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(int pid, ulong startTime, int uid)
	{
		auto p = polkit_unix_process_new_for_owner(pid, startTime, uid);

		if(p is null)
		{
			throw new ConstructionException("null returned by new_for_owner");
		}

		this(cast(PolkitUnixProcess*) p, true);
	}

	/**
	 * Creates a new #PolkitUnixProcess object for @pid and @start_time.
	 *
	 * The uid of the process will be looked up in using e.g. the
	 * <filename>/proc</filename> filesystem depending on the platform in
	 * use.
	 *
	 * Params:
	 *     pid = The process id.
	 *     startTime = The start time for @pid.
	 *
	 * Returns: A #PolkitSubject. Free with g_object_unref().
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(int pid, ulong startTime)
	{
		auto p = polkit_unix_process_new_full(pid, startTime);

		if(p is null)
		{
			throw new ConstructionException("null returned by new_full");
		}

		this(cast(PolkitUnixProcess*) p, true);
	}

	/**
	 * (deprecated)
	 *
	 * Throws: GException on failure.
	 */
	public int getOwner()
	{
		GError* err = null;

		auto p = polkit_unix_process_get_owner(polkitUnixProcess, &err);

		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}

		return p;
	}

	/**
	 * Gets the process id for @process.
	 *
	 * Returns: The process id for @process.
	 */
	public int getPid()
	{
		return polkit_unix_process_get_pid(polkitUnixProcess);
	}

	/**
	 * Gets the start time of @process.
	 *
	 * Returns: The start time of @process.
	 */
	public ulong getStartTime()
	{
		return polkit_unix_process_get_start_time(polkitUnixProcess);
	}

	/**
	 * Gets the user id for @process. Note that this is the real user-id,
	 * not the effective user-id.
	 *
	 * Returns: The user id for @process or -1 if unknown.
	 */
	public int getUid()
	{
		return polkit_unix_process_get_uid(polkitUnixProcess);
	}

	/**
	 * Sets @pid for @process.
	 *
	 * Params:
	 *     pid = A process id.
	 */
	public void setPid(int pid)
	{
		polkit_unix_process_set_pid(polkitUnixProcess, pid);
	}

	/**
	 * Set the start time of @process.
	 *
	 * Params:
	 *     startTime = The start time for @pid.
	 */
	public void setStartTime(ulong startTime)
	{
		polkit_unix_process_set_start_time(polkitUnixProcess, startTime);
	}

	/**
	 * Sets the (real, not effective) user id for @process.
	 *
	 * Params:
	 *     uid = The user id to set for @process or -1 to unset it.
	 */
	public void setUid(int uid)
	{
		polkit_unix_process_set_uid(polkitUnixProcess, uid);
	}
}
