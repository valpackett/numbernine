module polkit.ActionDescription;

private import glib.Str;
private import gobject.ObjectG;
private import polkit.c.functions;
public  import polkit.c.types;


/**
 * Object used to encapsulate a registered action.
 */
public class ActionDescription : ObjectG
{
	/** the main Gtk struct */
	protected PolkitActionDescription* polkitActionDescription;

	/** Get the main Gtk struct */
	public PolkitActionDescription* getActionDescriptionStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return polkitActionDescription;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)polkitActionDescription;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (PolkitActionDescription* polkitActionDescription, bool ownedRef = false)
	{
		this.polkitActionDescription = polkitActionDescription;
		super(cast(GObject*)polkitActionDescription, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return polkit_action_description_get_type();
	}

	/**
	 * Gets the action id for @action_description.
	 *
	 * Returns: A string owned by @action_description. Do not free.
	 */
	public string getActionId()
	{
		return Str.toString(polkit_action_description_get_action_id(polkitActionDescription));
	}

	/**
	 * Get the value of the annotation with @key.
	 *
	 * Params:
	 *     key = An annotation key.
	 *
	 * Returns: %NULL if there is no annoation with @key,
	 *     otherwise the annotation value owned by @action_description. Do not
	 *     free.
	 */
	public string getAnnotation(string key)
	{
		return Str.toString(polkit_action_description_get_annotation(polkitActionDescription, Str.toStringz(key)));
	}

	/**
	 * Gets the keys of annotations defined in @action_description.
	 *
	 * Returns: The annotation keys owned by @action_description. Do not free.
	 */
	public string[] getAnnotationKeys()
	{
		return Str.toStringArray(polkit_action_description_get_annotation_keys(polkitActionDescription));
	}

	/**
	 * Gets the description used for @action_description.
	 *
	 * Returns: A string owned by @action_description. Do not free.
	 */
	public string getDescription()
	{
		return Str.toString(polkit_action_description_get_description(polkitActionDescription));
	}

	/**
	 * Gets the icon name for @action_description, if any.
	 *
	 * Returns: A string owned by @action_description. Do not free.
	 */
	public string getIconName()
	{
		return Str.toString(polkit_action_description_get_icon_name(polkitActionDescription));
	}

	/**
	 * Gets the implicit authorization for @action_description used for
	 * subjects in active sessions on a local console.
	 *
	 * Returns: A value from the #PolkitImplicitAuthorization enumeration.
	 */
	public PolkitImplicitAuthorization getImplicitActive()
	{
		return polkit_action_description_get_implicit_active(polkitActionDescription);
	}

	/**
	 * Gets the implicit authorization for @action_description used for
	 * any subject.
	 *
	 * Returns: A value from the #PolkitImplicitAuthorization enumeration.
	 */
	public PolkitImplicitAuthorization getImplicitAny()
	{
		return polkit_action_description_get_implicit_any(polkitActionDescription);
	}

	/**
	 * Gets the implicit authorization for @action_description used for
	 * subjects in inactive sessions on a local console.
	 *
	 * Returns: A value from the #PolkitImplicitAuthorization enumeration.
	 */
	public PolkitImplicitAuthorization getImplicitInactive()
	{
		return polkit_action_description_get_implicit_inactive(polkitActionDescription);
	}

	/**
	 * Gets the message used for @action_description.
	 *
	 * Returns: A string owned by @action_description. Do not free.
	 */
	public string getMessage()
	{
		return Str.toString(polkit_action_description_get_message(polkitActionDescription));
	}

	/**
	 * Gets the vendor name for @action_description, if any.
	 *
	 * Returns: A string owned by @action_description. Do not free.
	 */
	public string getVendorName()
	{
		return Str.toString(polkit_action_description_get_vendor_name(polkitActionDescription));
	}

	/**
	 * Gets the vendor URL for @action_description, if any.
	 *
	 * Returns: A string owned by @action_description. Do not free.
	 */
	public string getVendorUrl()
	{
		return Str.toString(polkit_action_description_get_vendor_url(polkitActionDescription));
	}
}
