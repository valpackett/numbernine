module upower.c.functions;

import std.stdio;
import upower.c.types;
version (Windows)
	static immutable LIBRARY_UPOWER = ["glib-3.dll;g.dll;g.dll"];
else version (OSX)
	static immutable LIBRARY_UPOWER = ["glib.3.dylib"];
else
	static immutable LIBRARY_UPOWER = ["libupower-glib.so.3"];

__gshared extern(C)
{

	// upower.Client

	GType up_client_get_type();
	UpClient* up_client_new();
	UpClient* up_client_new_full(GCancellable* cancellable, GError** err);
	char* up_client_get_critical_action(UpClient* client);
	const(char)* up_client_get_daemon_version(UpClient* client);
	GPtrArray* up_client_get_devices(UpClient* client);
	UpDevice* up_client_get_display_device(UpClient* client);
	int up_client_get_lid_is_closed(UpClient* client);
	int up_client_get_lid_is_present(UpClient* client);
	int up_client_get_on_battery(UpClient* client);

	// upower.Device

	GType up_device_get_type();
	UpDevice* up_device_new();
	UpDeviceKind up_device_kind_from_string(const(char)* type);
	const(char)* up_device_kind_to_string(UpDeviceKind typeEnum);
	UpDeviceLevel up_device_level_from_string(const(char)* level);
	const(char)* up_device_level_to_string(UpDeviceLevel levelEnum);
	UpDeviceState up_device_state_from_string(const(char)* state);
	const(char)* up_device_state_to_string(UpDeviceState stateEnum);
	UpDeviceTechnology up_device_technology_from_string(const(char)* technology);
	const(char)* up_device_technology_to_string(UpDeviceTechnology technologyEnum);
	GPtrArray* up_device_get_history_sync(UpDevice* device, const(char)* type, uint timespec, uint resolution, GCancellable* cancellable, GError** err);
	const(char)* up_device_get_object_path(UpDevice* device);
	GPtrArray* up_device_get_statistics_sync(UpDevice* device, const(char)* type, GCancellable* cancellable, GError** err);
	int up_device_refresh_sync(UpDevice* device, GCancellable* cancellable, GError** err);
	int up_device_set_object_path_sync(UpDevice* device, const(char)* objectPath, GCancellable* cancellable, GError** err);
	char* up_device_to_text(UpDevice* device);

	// upower.HistoryItem

	GType up_history_item_get_type();
	UpHistoryItem* up_history_item_new();
	UpDeviceState up_history_item_get_state(UpHistoryItem* historyItem);
	uint up_history_item_get_time(UpHistoryItem* historyItem);
	double up_history_item_get_value(UpHistoryItem* historyItem);
	int up_history_item_set_from_string(UpHistoryItem* historyItem, const(char)* text);
	void up_history_item_set_state(UpHistoryItem* historyItem, UpDeviceState state);
	void up_history_item_set_time(UpHistoryItem* historyItem, uint time);
	void up_history_item_set_time_to_present(UpHistoryItem* historyItem);
	void up_history_item_set_value(UpHistoryItem* historyItem, double value);
	char* up_history_item_to_string(UpHistoryItem* historyItem);

	// upower.StatsItem

	GType up_stats_item_get_type();
	UpStatsItem* up_stats_item_new();
	double up_stats_item_get_accuracy(UpStatsItem* statsItem);
	double up_stats_item_get_value(UpStatsItem* statsItem);
	void up_stats_item_set_accuracy(UpStatsItem* statsItem, double accuracy);
	void up_stats_item_set_value(UpStatsItem* statsItem, double value);

	// upower.WakeupItem

	GType up_wakeup_item_get_type();
	UpWakeupItem* up_wakeup_item_new();
	const(char)* up_wakeup_item_get_cmdline(UpWakeupItem* wakeupItem);
	const(char)* up_wakeup_item_get_details(UpWakeupItem* wakeupItem);
	uint up_wakeup_item_get_id(UpWakeupItem* wakeupItem);
	int up_wakeup_item_get_is_userspace(UpWakeupItem* wakeupItem);
	uint up_wakeup_item_get_old(UpWakeupItem* wakeupItem);
	double up_wakeup_item_get_value(UpWakeupItem* wakeupItem);
	void up_wakeup_item_set_cmdline(UpWakeupItem* wakeupItem, const(char)* cmdline);
	void up_wakeup_item_set_details(UpWakeupItem* wakeupItem, const(char)* details);
	void up_wakeup_item_set_id(UpWakeupItem* wakeupItem, uint id);
	void up_wakeup_item_set_is_userspace(UpWakeupItem* wakeupItem, int isUserspace);
	void up_wakeup_item_set_old(UpWakeupItem* wakeupItem, uint old);
	void up_wakeup_item_set_value(UpWakeupItem* wakeupItem, double value);

	// upower.Wakeups

	GType up_wakeups_get_type();
	UpWakeups* up_wakeups_new();
	GPtrArray* up_wakeups_get_data_sync(UpWakeups* wakeups, GCancellable* cancellable, GError** err);
	int up_wakeups_get_has_capability(UpWakeups* wakeups);
	int up_wakeups_get_properties_sync(UpWakeups* wakeups, GCancellable* cancellable, GError** err);
	uint up_wakeups_get_total_sync(UpWakeups* wakeups, GCancellable* cancellable, GError** err);
}