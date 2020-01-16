module handy.ComboRow;

private import gio.ListModelIF;
private import glib.ConstructionException;
private import gobject.ObjectG;
private import handy.ActionRow;
private import handy.c.functions;
public  import handy.c.types;


/** */
public class ComboRow : ActionRow
{
	/** the main Gtk struct */
	protected HdyComboRow* hdyComboRow;

	/** Get the main Gtk struct */
	public HdyComboRow* getComboRowStruct(bool transferOwnership = false)
	{
		if (transferOwnership)
			ownedRef = false;
		return hdyComboRow;
	}

	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)hdyComboRow;
	}

	/**
	 * Sets our main struct and passes it to the parent class.
	 */
	public this (HdyComboRow* hdyComboRow, bool ownedRef = false)
	{
		this.hdyComboRow = hdyComboRow;
		super(cast(HdyActionRow*)hdyComboRow, ownedRef);
	}


	/** */
	public static GType getType()
	{
		return hdy_combo_row_get_type();
	}

	/**
	 * Creates a new #HdyComboRow.
	 *
	 * Returns: a new #HdyComboRow
	 *
	 * Since: 0.0.6
	 *
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this()
	{
		auto __p = hdy_combo_row_new();

		if(__p is null)
		{
			throw new ConstructionException("null returned by new");
		}

		this(cast(HdyComboRow*) __p);
	}

	/**
	 * Binds @model to @self.
	 *
	 * If @self was already bound to a model, that previous binding is destroyed.
	 *
	 * The contents of @self are cleared and then filled with widgets that represent
	 * items from @model. @self is updated whenever @model changes. If @model is
	 * %NULL, @self is left empty.
	 *
	 * Params:
	 *     model = the #GListModel to be bound to @self
	 *     createListWidgetFunc = a function that creates
	 *         widgets for items to display in the list, or %NULL in case you also passed
	 *         %NULL as @model
	 *     createCurrentWidgetFunc = a function that creates
	 *         widgets for items to display as the seleted item, or %NULL in case you also
	 *         passed %NULL as @model
	 *     userData = user data passed to @create_list_widget_func and
	 *         @create_current_widget_func
	 *     userDataFreeFunc = function for freeing @user_data
	 *
	 * Since: 0.0.6
	 */
	public void bindModel(ListModelIF model, GtkListBoxCreateWidgetFunc createListWidgetFunc, GtkListBoxCreateWidgetFunc createCurrentWidgetFunc, void* userData, GDestroyNotify userDataFreeFunc)
	{
		hdy_combo_row_bind_model(hdyComboRow, (model is null) ? null : model.getListModelStruct(), createListWidgetFunc, createCurrentWidgetFunc, userData, userDataFreeFunc);
	}

	/**
	 * Binds @model to @self.
	 *
	 * If @self was already bound to a model, that previous binding is destroyed.
	 *
	 * The contents of @self are cleared and then filled with widgets that represent
	 * items from @model. @self is updated whenever @model changes. If @model is
	 * %NULL, @self is left empty.
	 *
	 * This is more conventient to use than hdy_combo_row_bind_model() if you want
	 * to represent items of the model with names.
	 *
	 * Params:
	 *     model = the #GListModel to be bound to @self
	 *     getNameFunc = a function that creates names for items, or %NULL
	 *         in case you also passed %NULL as @model
	 *     userData = user data passed to @get_name_func
	 *     userDataFreeFunc = function for freeing @user_data
	 *
	 * Since: 0.0.6
	 */
	public void bindNameModel(ListModelIF model, HdyComboRowGetNameFunc getNameFunc, void* userData, GDestroyNotify userDataFreeFunc)
	{
		hdy_combo_row_bind_name_model(hdyComboRow, (model is null) ? null : model.getListModelStruct(), getNameFunc, userData, userDataFreeFunc);
	}

	/**
	 * Gets the model bound to @self, or %NULL if none is bound.
	 *
	 * Returns: the #GListModel bound to @self or %NULL
	 *
	 * Since: 0.0.6
	 */
	public ListModelIF getModel()
	{
		auto __p = hdy_combo_row_get_model(hdyComboRow);

		if(__p is null)
		{
			return null;
		}

		return ObjectG.getDObject!(ListModelIF)(cast(GListModel*) __p);
	}

	/**
	 * Gets the index of the selected item in its #GListModel.
	 *
	 * Returns: the index of the selected item, or -1 if no item is selected
	 *
	 * Since: 0.0.7
	 */
	public int getSelectedIndex()
	{
		return hdy_combo_row_get_selected_index(hdyComboRow);
	}

	/**
	 * Gets whether the current value of @self should be displayed as its subtitle.
	 *
	 * Returns: whether the current value of @self should be displayed as its subtitle
	 *
	 * Since: 0.0.10
	 */
	public bool getUseSubtitle()
	{
		return hdy_combo_row_get_use_subtitle(hdyComboRow) != 0;
	}

	/**
	 * Creates a model for @enum_type and binds it to @self. The items of the model
	 * will be #HdyEnumValueObject objects.
	 *
	 * If @self was already bound to a model, that previous binding is destroyed.
	 *
	 * The contents of @self are cleared and then filled with widgets that represent
	 * items from @model. @self is updated whenever @model changes. If @model is
	 * %NULL, @self is left empty.
	 *
	 * This is more conventient to use than hdy_combo_row_bind_name_model() if you
	 * want to represent values of an enumeration with names.
	 *
	 * See hdy_enum_value_row_name().
	 *
	 * Params:
	 *     enumType = the enumeration #GType to be bound to @self
	 *     getNameFunc = a function that creates names for items, or %NULL
	 *         in case you also passed %NULL as @model
	 *     userData = user data passed to @get_name_func
	 *     userDataFreeFunc = function for freeing @user_data
	 *
	 * Since: 0.0.6
	 */
	public void setForEnum(GType enumType, HdyComboRowGetEnumValueNameFunc getNameFunc, void* userData, GDestroyNotify userDataFreeFunc)
	{
		hdy_combo_row_set_for_enum(hdyComboRow, enumType, getNameFunc, userData, userDataFreeFunc);
	}

	/**
	 * Sets a closure to convert items into names. See HdyComboRow:use-subtitle.
	 *
	 * Params:
	 *     getNameFunc = a function that creates names for items, or %NULL
	 *         in case you also passed %NULL as @model
	 *     userData = user data passed to @get_name_func
	 *     userDataFreeFunc = function for freeing @user_data
	 *
	 * Since: 0.0.10
	 */
	public void setGetNameFunc(HdyComboRowGetNameFunc getNameFunc, void* userData, GDestroyNotify userDataFreeFunc)
	{
		hdy_combo_row_set_get_name_func(hdyComboRow, getNameFunc, userData, userDataFreeFunc);
	}

	/**
	 * Sets the index of the selected item in its #GListModel.
	 *
	 * Params:
	 *     selectedIndex = the index of the selected item
	 *
	 * Since: 0.0.7
	 */
	public void setSelectedIndex(int selectedIndex)
	{
		hdy_combo_row_set_selected_index(hdyComboRow, selectedIndex);
	}

	/**
	 * Sets whether the current value of @self should be displayed as its subtitle.
	 *
	 * If %TRUE, you should not access HdyActionRow:subtitle.
	 *
	 * Params:
	 *     useSubtitle = %TRUE to set the current value as the subtitle
	 *
	 * Since: 0.0.10
	 */
	public void setUseSubtitle(bool useSubtitle)
	{
		hdy_combo_row_set_use_subtitle(hdyComboRow, useSubtitle);
	}
}
