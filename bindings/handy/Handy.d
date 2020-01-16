module handy.Handy;

private import glib.Str;
private import handy.c.functions;
public  import handy.c.types;


/** */
public struct Handy
{

	/**
	 * Call this function before using any other Handy functions in your
	 * GUI applications. If libhandy has already been initialized, the function will
	 * simply return without processing the new arguments.
	 *
	 * Params:
	 *     argv = Address of the <parameter>argv</parameter> parameter of main(), or %NULL.
	 *         Any options understood by Handy are stripped before return.
	 *
	 * Returns: %TRUE if initialization was successful, %FALSE otherwise.
	 */
	public static bool init(ref string[] argv)
	{
		int argc = cast(int)argv.length;
		char** outargv = Str.toStringzArray(argv);

		auto __p = hdy_init(&argc, &outargv) != 0;

		argv = Str.toStringArray(outargv, argc);

		return __p;
	}
}
