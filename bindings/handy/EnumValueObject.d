module handy.EnumValueObject;

private import glib.ConstructionException;
private import glib.Str;
private import gobject.ObjectG;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class EnumValueObject : ObjectG
{
	/** the main Gtk struct */
	protected HdyEnumValueObject* hdyEnumValueObject;

	/** Get the main Gtk struct */
	public HdyEnumValueObject* getEnumValueObjectStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyEnumValueObject;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyEnumValueObject;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyEnumValueObject* hdyEnumValueObject, bool ownedRef = false)
	{
		this.hdyEnumValueObject = hdyEnumValueObject;
		super(cast(GObject*)hdyEnumValueObject, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_enum_value_object_get_type();
	}

	/** */
	public this(GEnumValue* enumValue)
	{
		auto __p = hdy_enum_value_object_new(enumValue);

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyEnumValueObject*) __p, true);
	}

	/** */
	public string getName()
	{
		return Str.toString(hdy_enum_value_object_get_name(hdyEnumValueObject));
	}

	/** */
	public string getNick()
	{
		return Str.toString(hdy_enum_value_object_get_nick(hdyEnumValueObject));
	}

	/** */
	public int getValue()
	{
		return hdy_enum_value_object_get_value(hdyEnumValueObject);
	}
}
