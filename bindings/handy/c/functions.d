module handy.c.functions;

import std.stdio;
import handy.c.types;
version (Windows)
	static immutable LIBRARY_HANDY = ["libhandy-0.0-0.dll;handy-0.0-0.dll;handy-0.dll"];
else version (OSX)
	static immutable LIBRARY_HANDY = ["libhandy-0.0.0.dylib"];
else
	static immutable LIBRARY_HANDY = ["libhandy-0.0.so.0"];

__gshared extern(C)
{

	// handy.ActionRow

	GType hdy_action_row_get_type();
	HdyActionRow* hdy_action_row_new();
	void hdy_action_row_activate(HdyActionRow* self);
	void hdy_action_row_add_action(HdyActionRow* self, GtkWidget* widget);
	void hdy_action_row_add_prefix(HdyActionRow* self, GtkWidget* widget);
	GtkWidget* hdy_action_row_get_activatable_widget(HdyActionRow* self);
	const(char)* hdy_action_row_get_icon_name(HdyActionRow* self);
	const(char)* hdy_action_row_get_subtitle(HdyActionRow* self);
	const(char)* hdy_action_row_get_title(HdyActionRow* self);
	int hdy_action_row_get_use_underline(HdyActionRow* self);
	void hdy_action_row_set_activatable_widget(HdyActionRow* self, GtkWidget* widget);
	void hdy_action_row_set_icon_name(HdyActionRow* self, const(char)* iconName);
	void hdy_action_row_set_subtitle(HdyActionRow* self, const(char)* subtitle);
	void hdy_action_row_set_title(HdyActionRow* self, const(char)* title);
	void hdy_action_row_set_use_underline(HdyActionRow* self, int useUnderline);

	// handy.Arrows

	GType hdy_arrows_get_type();
	GtkWidget* hdy_arrows_new();
	void hdy_arrows_animate(HdyArrows* self);
	uint hdy_arrows_get_count(HdyArrows* self);
	HdyArrowsDirection hdy_arrows_get_direction(HdyArrows* self);
	uint hdy_arrows_get_duration(HdyArrows* self);
	void hdy_arrows_set_count(HdyArrows* self, uint count);
	void hdy_arrows_set_direction(HdyArrows* self, HdyArrowsDirection direction);
	void hdy_arrows_set_duration(HdyArrows* self, uint duration);

	// handy.Column

	GType hdy_column_get_type();
	HdyColumn* hdy_column_new();
	int hdy_column_get_linear_growth_width(HdyColumn* self);
	int hdy_column_get_maximum_width(HdyColumn* self);
	void hdy_column_set_linear_growth_width(HdyColumn* self, int linearGrowthWidth);
	void hdy_column_set_maximum_width(HdyColumn* self, int maximumWidth);

	// handy.ComboRow

	GType hdy_combo_row_get_type();
	HdyComboRow* hdy_combo_row_new();
	void hdy_combo_row_bind_model(HdyComboRow* self, GListModel* model, GtkListBoxCreateWidgetFunc createListWidgetFunc, GtkListBoxCreateWidgetFunc createCurrentWidgetFunc, void* userData, GDestroyNotify userDataFreeFunc);
	void hdy_combo_row_bind_name_model(HdyComboRow* self, GListModel* model, HdyComboRowGetNameFunc getNameFunc, void* userData, GDestroyNotify userDataFreeFunc);
	GListModel* hdy_combo_row_get_model(HdyComboRow* self);
	int hdy_combo_row_get_selected_index(HdyComboRow* self);
	int hdy_combo_row_get_use_subtitle(HdyComboRow* self);
	void hdy_combo_row_set_for_enum(HdyComboRow* self, GType enumType, HdyComboRowGetEnumValueNameFunc getNameFunc, void* userData, GDestroyNotify userDataFreeFunc);
	void hdy_combo_row_set_get_name_func(HdyComboRow* self, HdyComboRowGetNameFunc getNameFunc, void* userData, GDestroyNotify userDataFreeFunc);
	void hdy_combo_row_set_selected_index(HdyComboRow* self, int selectedIndex);
	void hdy_combo_row_set_use_subtitle(HdyComboRow* self, int useSubtitle);

	// handy.Dialer

	GType hdy_dialer_get_type();
	GtkWidget* hdy_dialer_new();
	void hdy_dialer_clear_number(HdyDialer* self);
	const(char)* hdy_dialer_get_number(HdyDialer* self);
	GtkReliefStyle hdy_dialer_get_relief(HdyDialer* self);
	int hdy_dialer_get_show_action_buttons(HdyDialer* self);
	void hdy_dialer_set_number(HdyDialer* self, const(char)* number);
	void hdy_dialer_set_relief(HdyDialer* self, GtkReliefStyle relief);
	void hdy_dialer_set_show_action_buttons(HdyDialer* self, int show);

	// handy.DialerButton

	GType hdy_dialer_button_get_type();
	GtkWidget* hdy_dialer_button_new(const(char)* symbols);
	int hdy_dialer_button_get_digit(HdyDialerButton* self);
	const(char)* hdy_dialer_button_get_symbols(HdyDialerButton* self);

	// handy.DialerCycleButton

	GType hdy_dialer_cycle_button_get_type();
	GtkWidget* hdy_dialer_cycle_button_new(const(char)* symbols);
	dchar hdy_dialer_cycle_button_get_current_symbol(HdyDialerCycleButton* self);
	int hdy_dialer_cycle_button_get_cycle_timeout(HdyDialerCycleButton* self);
	int hdy_dialer_cycle_button_is_cycling(HdyDialerCycleButton* self);
	void hdy_dialer_cycle_button_set_cycle_timeout(HdyDialerCycleButton* self, int timeout);
	void hdy_dialer_cycle_button_stop_cycle(HdyDialerCycleButton* self);

	// handy.Dialog

	GType hdy_dialog_get_type();
	GtkWidget* hdy_dialog_new(GtkWindow* parent);

	// handy.EnumValueObject

	GType hdy_enum_value_object_get_type();
	HdyEnumValueObject* hdy_enum_value_object_new(GEnumValue* enumValue);
	const(char)* hdy_enum_value_object_get_name(HdyEnumValueObject* self);
	const(char)* hdy_enum_value_object_get_nick(HdyEnumValueObject* self);
	int hdy_enum_value_object_get_value(HdyEnumValueObject* self);

	// handy.ExpanderRow

	GType hdy_expander_row_get_type();
	HdyExpanderRow* hdy_expander_row_new();
	int hdy_expander_row_get_enable_expansion(HdyExpanderRow* self);
	int hdy_expander_row_get_expanded(HdyExpanderRow* self);
	int hdy_expander_row_get_show_enable_switch(HdyExpanderRow* self);
	void hdy_expander_row_set_enable_expansion(HdyExpanderRow* self, int enableExpansion);
	void hdy_expander_row_set_expanded(HdyExpanderRow* self, int expanded);
	void hdy_expander_row_set_show_enable_switch(HdyExpanderRow* self, int showEnableSwitch);

	// handy.HeaderBar

	GType hdy_header_bar_get_type();
	GtkWidget* hdy_header_bar_new();
	HdyCenteringPolicy hdy_header_bar_get_centering_policy(HdyHeaderBar* self);
	GtkWidget* hdy_header_bar_get_custom_title(HdyHeaderBar* self);
	const(char)* hdy_header_bar_get_decoration_layout(HdyHeaderBar* self);
	int hdy_header_bar_get_has_subtitle(HdyHeaderBar* self);
	int hdy_header_bar_get_interpolate_size(HdyHeaderBar* self);
	int hdy_header_bar_get_show_close_button(HdyHeaderBar* self);
	const(char)* hdy_header_bar_get_subtitle(HdyHeaderBar* self);
	const(char)* hdy_header_bar_get_title(HdyHeaderBar* self);
	uint hdy_header_bar_get_transition_duration(HdyHeaderBar* self);
	int hdy_header_bar_get_transition_running(HdyHeaderBar* self);
	void hdy_header_bar_pack_end(HdyHeaderBar* self, GtkWidget* child);
	void hdy_header_bar_pack_start(HdyHeaderBar* self, GtkWidget* child);
	void hdy_header_bar_set_centering_policy(HdyHeaderBar* self, HdyCenteringPolicy centeringPolicy);
	void hdy_header_bar_set_custom_title(HdyHeaderBar* self, GtkWidget* titleWidget);
	void hdy_header_bar_set_decoration_layout(HdyHeaderBar* self, const(char)* layout);
	void hdy_header_bar_set_has_subtitle(HdyHeaderBar* self, int setting);
	void hdy_header_bar_set_interpolate_size(HdyHeaderBar* self, int interpolateSize);
	void hdy_header_bar_set_show_close_button(HdyHeaderBar* self, int setting);
	void hdy_header_bar_set_subtitle(HdyHeaderBar* self, const(char)* subtitle);
	void hdy_header_bar_set_title(HdyHeaderBar* self, const(char)* title);
	void hdy_header_bar_set_transition_duration(HdyHeaderBar* self, uint duration);

	// handy.HeaderGroup

	GType hdy_header_group_get_type();
	HdyHeaderGroup* hdy_header_group_new();
	void hdy_header_group_add_header_bar(HdyHeaderGroup* self, GtkHeaderBar* headerBar);
	GtkHeaderBar* hdy_header_group_get_focus(HdyHeaderGroup* self);
	GSList* hdy_header_group_get_header_bars(HdyHeaderGroup* self);
	void hdy_header_group_remove_header_bar(HdyHeaderGroup* self, GtkHeaderBar* headerBar);
	void hdy_header_group_set_focus(HdyHeaderGroup* self, GtkHeaderBar* headerBar);

	// handy.Leaflet

	GType hdy_leaflet_get_type();
	GtkWidget* hdy_leaflet_new();
	uint hdy_leaflet_get_child_transition_duration(HdyLeaflet* self);
	int hdy_leaflet_get_child_transition_running(HdyLeaflet* self);
	HdyLeafletChildTransitionType hdy_leaflet_get_child_transition_type(HdyLeaflet* self);
	HdyFold hdy_leaflet_get_fold(HdyLeaflet* self);
	int hdy_leaflet_get_homogeneous(HdyLeaflet* self, HdyFold fold, GtkOrientation orientation);
	int hdy_leaflet_get_interpolate_size(HdyLeaflet* self);
	uint hdy_leaflet_get_mode_transition_duration(HdyLeaflet* self);
	HdyLeafletModeTransitionType hdy_leaflet_get_mode_transition_type(HdyLeaflet* self);
	GtkWidget* hdy_leaflet_get_visible_child(HdyLeaflet* self);
	const(char)* hdy_leaflet_get_visible_child_name(HdyLeaflet* self);
	void hdy_leaflet_set_child_transition_duration(HdyLeaflet* self, uint duration);
	void hdy_leaflet_set_child_transition_type(HdyLeaflet* self, HdyLeafletChildTransitionType transition);
	void hdy_leaflet_set_homogeneous(HdyLeaflet* self, HdyFold fold, GtkOrientation orientation, int homogeneous);
	void hdy_leaflet_set_interpolate_size(HdyLeaflet* self, int interpolateSize);
	void hdy_leaflet_set_mode_transition_duration(HdyLeaflet* self, uint duration);
	void hdy_leaflet_set_mode_transition_type(HdyLeaflet* self, HdyLeafletModeTransitionType transition);
	void hdy_leaflet_set_visible_child(HdyLeaflet* self, GtkWidget* visibleChild);
	void hdy_leaflet_set_visible_child_name(HdyLeaflet* self, const(char)* name);

	// handy.PreferencesGroup

	GType hdy_preferences_group_get_type();
	HdyPreferencesGroup* hdy_preferences_group_new();
	const(char)* hdy_preferences_group_get_description(HdyPreferencesGroup* self);
	const(char)* hdy_preferences_group_get_title(HdyPreferencesGroup* self);
	void hdy_preferences_group_set_description(HdyPreferencesGroup* self, const(char)* description);
	void hdy_preferences_group_set_title(HdyPreferencesGroup* self, const(char)* title);

	// handy.PreferencesPage

	GType hdy_preferences_page_get_type();
	HdyPreferencesPage* hdy_preferences_page_new();
	const(char)* hdy_preferences_page_get_icon_name(HdyPreferencesPage* self);
	const(char)* hdy_preferences_page_get_title(HdyPreferencesPage* self);
	void hdy_preferences_page_set_icon_name(HdyPreferencesPage* self, const(char)* iconName);
	void hdy_preferences_page_set_title(HdyPreferencesPage* self, const(char)* title);

	// handy.PreferencesRow

	GType hdy_preferences_row_get_type();
	HdyPreferencesRow* hdy_preferences_row_new();
	const(char)* hdy_preferences_row_get_title(HdyPreferencesRow* self);
	int hdy_preferences_row_get_use_underline(HdyPreferencesRow* self);
	void hdy_preferences_row_set_title(HdyPreferencesRow* self, const(char)* title);
	void hdy_preferences_row_set_use_underline(HdyPreferencesRow* self, int useUnderline);

	// handy.PreferencesWindow

	GType hdy_preferences_window_get_type();
	HdyPreferencesWindow* hdy_preferences_window_new();

	// handy.SearchBar

	GType hdy_search_bar_get_type();
	GtkWidget* hdy_search_bar_new();
	void hdy_search_bar_connect_entry(HdySearchBar* self, GtkEntry* entry);
	int hdy_search_bar_get_search_mode(HdySearchBar* self);
	int hdy_search_bar_get_show_close_button(HdySearchBar* self);
	int hdy_search_bar_handle_event(HdySearchBar* self, GdkEvent* event);
	void hdy_search_bar_set_search_mode(HdySearchBar* self, int searchMode);
	void hdy_search_bar_set_show_close_button(HdySearchBar* self, int visible);

	// handy.Squeezer

	GType hdy_squeezer_get_type();
	HdySqueezer* hdy_squeezer_new();
	int hdy_squeezer_get_child_enabled(HdySqueezer* self, GtkWidget* child);
	int hdy_squeezer_get_homogeneous(HdySqueezer* self);
	int hdy_squeezer_get_interpolate_size(HdySqueezer* self);
	uint hdy_squeezer_get_transition_duration(HdySqueezer* self);
	int hdy_squeezer_get_transition_running(HdySqueezer* self);
	HdySqueezerTransitionType hdy_squeezer_get_transition_type(HdySqueezer* self);
	GtkWidget* hdy_squeezer_get_visible_child(HdySqueezer* self);
	void hdy_squeezer_set_child_enabled(HdySqueezer* self, GtkWidget* child, int enabled);
	void hdy_squeezer_set_homogeneous(HdySqueezer* self, int homogeneous);
	void hdy_squeezer_set_interpolate_size(HdySqueezer* self, int interpolateSize);
	void hdy_squeezer_set_transition_duration(HdySqueezer* self, uint duration);
	void hdy_squeezer_set_transition_type(HdySqueezer* self, HdySqueezerTransitionType transition);

	// handy.TitleBar

	GType hdy_title_bar_get_type();
	HdyTitleBar* hdy_title_bar_new();
	int hdy_title_bar_get_selection_mode(HdyTitleBar* self);
	void hdy_title_bar_set_selection_mode(HdyTitleBar* self, int selectionMode);

	// handy.ValueObject

	GType hdy_value_object_get_type();
	HdyValueObject* hdy_value_object_new(GValue* value);
	HdyValueObject* hdy_value_object_new_collect(GType type, ... );
	HdyValueObject* hdy_value_object_new_string(const(char)* string_);
	HdyValueObject* hdy_value_object_new_take_string(char* string_);
	void hdy_value_object_copy_value(HdyValueObject* value, GValue* dest);
	char* hdy_value_object_dup_string(HdyValueObject* value);
	const(char)* hdy_value_object_get_string(HdyValueObject* value);
	GValue* hdy_value_object_get_value(HdyValueObject* value);

	// handy.ViewSwitcher

	GType hdy_view_switcher_get_type();
	HdyViewSwitcher* hdy_view_switcher_new();
	GtkIconSize hdy_view_switcher_get_icon_size(HdyViewSwitcher* self);
	PangoEllipsizeMode hdy_view_switcher_get_narrow_ellipsize(HdyViewSwitcher* self);
	HdyViewSwitcherPolicy hdy_view_switcher_get_policy(HdyViewSwitcher* self);
	GtkStack* hdy_view_switcher_get_stack(HdyViewSwitcher* self);
	void hdy_view_switcher_set_icon_size(HdyViewSwitcher* self, GtkIconSize iconSize);
	void hdy_view_switcher_set_narrow_ellipsize(HdyViewSwitcher* self, PangoEllipsizeMode mode);
	void hdy_view_switcher_set_policy(HdyViewSwitcher* self, HdyViewSwitcherPolicy policy);
	void hdy_view_switcher_set_stack(HdyViewSwitcher* self, GtkStack* stack);

	// handy.ViewSwitcherBar

	GType hdy_view_switcher_bar_get_type();
	HdyViewSwitcherBar* hdy_view_switcher_bar_new();
	GtkIconSize hdy_view_switcher_bar_get_icon_size(HdyViewSwitcherBar* self);
	HdyViewSwitcherPolicy hdy_view_switcher_bar_get_policy(HdyViewSwitcherBar* self);
	int hdy_view_switcher_bar_get_reveal(HdyViewSwitcherBar* self);
	GtkStack* hdy_view_switcher_bar_get_stack(HdyViewSwitcherBar* self);
	void hdy_view_switcher_bar_set_icon_size(HdyViewSwitcherBar* self, GtkIconSize iconSize);
	void hdy_view_switcher_bar_set_policy(HdyViewSwitcherBar* self, HdyViewSwitcherPolicy policy);
	void hdy_view_switcher_bar_set_reveal(HdyViewSwitcherBar* self, int reveal);
	void hdy_view_switcher_bar_set_stack(HdyViewSwitcherBar* self, GtkStack* stack);

	// handy.Handy

	int hdy_init(int* argc, char*** argv);
}