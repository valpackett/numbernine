module polkit.c.types;

public import gio.c.types;
public import glib.c.types;
public import gobject.c.types;


/**
 * Flags describing features supported by the Authority implementation.
 */
public enum PolkitAuthorityFeatures
{
	/**
	 * No flags set.
	 */
	NONE = 0,
	/**
	 * The authority supports temporary authorizations
	 * that can be obtained through authentication.
	 */
	TEMPORARY_AUTHORIZATION = 1,
}
alias PolkitAuthorityFeatures AuthorityFeatures;

/**
 * Possible flags when checking authorizations.
 */
public enum PolkitCheckAuthorizationFlags
{
	/**
	 * No flags set.
	 */
	NONE = 0,
	/**
	 * If the subject can obtain the authorization
	 * through authentication, and an authentication agent is available, then attempt to do so. Note, this
	 * means that the method used for checking authorization is likely to block for a long time.
	 */
	ALLOW_USER_INTERACTION = 1,
}
alias PolkitCheckAuthorizationFlags CheckAuthorizationFlags;

/**
 * Possible error when using PolicyKit.
 */
public enum PolkitError
{
	/**
	 * The operation failed.
	 */
	FAILED = 0,
	/**
	 * The operation was cancelled.
	 */
	CANCELLED = 1,
	/**
	 * Operation is not supported.
	 */
	NOT_SUPPORTED = 2,
	/**
	 * Not authorized to perform operation.
	 */
	NOT_AUTHORIZED = 3,
}
alias PolkitError Error;

/**
 * Possible implicit authorizations.
 */
public enum PolkitImplicitAuthorization
{
	/**
	 * Unknown whether the subject is authorized, never returned in any public API.
	 */
	UNKNOWN = -1,
	/**
	 * Subject is not authorized.
	 */
	NOT_AUTHORIZED = 0,
	/**
	 * Authentication is required.
	 */
	AUTHENTICATION_REQUIRED = 1,
	/**
	 * Authentication as an administrator is required.
	 */
	ADMINISTRATOR_AUTHENTICATION_REQUIRED = 2,
	/**
	 * Authentication is required. If the authorization is obtained, it is retained.
	 */
	AUTHENTICATION_REQUIRED_RETAINED = 3,
	/**
	 * Authentication as an administrator is required. If the authorization is obtained, it is retained.
	 */
	ADMINISTRATOR_AUTHENTICATION_REQUIRED_RETAINED = 4,
	/**
	 * The subject is authorized
	 */
	AUTHORIZED = 5,
}
alias PolkitImplicitAuthorization ImplicitAuthorization;

struct PolkitActionDescription;

struct PolkitActionDescriptionClass;

struct PolkitAuthority;

struct PolkitAuthorityClass;

struct PolkitAuthorizationResult;

struct PolkitAuthorizationResultClass;

struct PolkitDetails;

struct PolkitDetailsClass;

struct PolkitIdentity;

/**
 * An interface for identities.
 */
struct PolkitIdentityIface
{
	/**
	 * The parent interface.
	 */
	GTypeInterface parentIface;
	/**
	 *
	 * Params:
	 *     identity = A #PolkitIdentity.
	 * Returns: A hash code.
	 */
	extern(C) uint function(PolkitIdentity* identity) hash;
	/**
	 *
	 * Params:
	 *     a = A #PolkitIdentity.
	 *     b = A #PolkitIdentity.
	 * Returns: %TRUE if @a and @b are equal, %FALSE otherwise.
	 */
	extern(C) int function(PolkitIdentity* a, PolkitIdentity* b) equal;
	/**
	 *
	 * Params:
	 *     identity = A #PolkitIdentity.
	 * Returns: A string representing @identity. Free with g_free().
	 */
	extern(C) char* function(PolkitIdentity* identity) toString;
}

struct PolkitPermission;

struct PolkitSubject;

/**
 * An interface for subjects.
 */
struct PolkitSubjectIface
{
	/**
	 * The parent interface.
	 */
	GTypeInterface parentIface;
	/**
	 *
	 * Params:
	 *     subject = A #PolkitSubject.
	 * Returns: A hash code.
	 */
	extern(C) uint function(PolkitSubject* subject) hash;
	/**
	 *
	 * Params:
	 *     a = A #PolkitSubject.
	 *     b = A #PolkitSubject.
	 * Returns: %TRUE if @a and @b are equal, %FALSE otherwise.
	 */
	extern(C) int function(PolkitSubject* a, PolkitSubject* b) equal;
	/**
	 *
	 * Params:
	 *     subject = A #PolkitSubject.
	 * Returns: A string representing @subject. Free with g_free().
	 */
	extern(C) char* function(PolkitSubject* subject) toString;
	/** */
	extern(C) void function(PolkitSubject* subject, GCancellable* cancellable, GAsyncReadyCallback callback, void* userData) exists;
	/**
	 *
	 * Params:
	 *     subject = A #PolkitSubject.
	 *     res = A #GAsyncResult obtained from the #GAsyncReadyCallback passed to polkit_subject_exists().
	 * Returns: %TRUE if the subject exists, %FALSE if not or @error is set.
	 *
	 * Throws: GException on failure.
	 */
	extern(C) int function(PolkitSubject* subject, GAsyncResult* res, GError** err) existsFinish;
	/**
	 *
	 * Params:
	 *     subject = A #PolkitSubject.
	 *     cancellable = A #GCancellable or %NULL.
	 * Returns: %TRUE if the subject exists, %FALSE if not or @error is set.
	 *
	 * Throws: GException on failure.
	 */
	extern(C) int function(PolkitSubject* subject, GCancellable* cancellable, GError** err) existsSync;
}

struct PolkitSystemBusName;

struct PolkitSystemBusNameClass;

struct PolkitTemporaryAuthorization;

struct PolkitTemporaryAuthorizationClass;

struct PolkitUnixGroup;

struct PolkitUnixGroupClass;

struct PolkitUnixNetgroup;

struct PolkitUnixNetgroupClass;

struct PolkitUnixProcess;

struct PolkitUnixProcessClass;

struct PolkitUnixSession;

struct PolkitUnixSessionClass;

struct PolkitUnixUser;

struct PolkitUnixUserClass;
