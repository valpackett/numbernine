module upower.c.types;

public import gio.c.types;
public import glib.c.types;
public import gobject.c.types;


/**
 * The device type.
 */
public enum UpDeviceKind
{
	UNKNOWN = 0,
	LINE_POWER = 1,
	BATTERY = 2,
	UPS = 3,
	MONITOR = 4,
	MOUSE = 5,
	KEYBOARD = 6,
	PDA = 7,
	PHONE = 8,
	MEDIA_PLAYER = 9,
	TABLET = 10,
	COMPUTER = 11,
	GAMING_INPUT = 12,
	LAST = 13,
}
alias UpDeviceKind DeviceKind;

/**
 * The level of a battery. Only values up to, and including
 * %UP_DEVICE_LEVEL_ACTION are relevant for the #WarningLevel.
 * The #BatteryLevel only uses the following values:
 * - %UP_DEVICE_LEVEL_UNKNOWN
 * - %UP_DEVICE_LEVEL_NONE
 * - %UP_DEVICE_LEVEL_LOW
 * - %UP_DEVICE_LEVEL_CRITICAL
 * - %UP_DEVICE_LEVEL_NORMAL
 * - %UP_DEVICE_LEVEL_HIGH
 * - %UP_DEVICE_LEVEL_FULL
 */
public enum UpDeviceLevel
{
	UNKNOWN = 0,
	NONE = 1,
	DISCHARGING = 2,
	LOW = 3,
	CRITICAL = 4,
	ACTION = 5,
	NORMAL = 6,
	HIGH = 7,
	FULL = 8,
	LAST = 9,
}
alias UpDeviceLevel DeviceLevel;

/**
 * The device state.
 */
public enum UpDeviceState
{
	UNKNOWN = 0,
	CHARGING = 1,
	DISCHARGING = 2,
	EMPTY = 3,
	FULLY_CHARGED = 4,
	PENDING_CHARGE = 5,
	PENDING_DISCHARGE = 6,
	LAST = 7,
}
alias UpDeviceState DeviceState;

/**
 * The device technology.
 */
public enum UpDeviceTechnology
{
	UNKNOWN = 0,
	LITHIUM_ION = 1,
	LITHIUM_POLYMER = 2,
	LITHIUM_IRON_PHOSPHATE = 3,
	LEAD_ACID = 4,
	NICKEL_CADMIUM = 5,
	NICKEL_METAL_HYDRIDE = 6,
	LAST = 7,
}
alias UpDeviceTechnology DeviceTechnology;

struct UpClient
{
	GObject parent;
	UpClientPrivate* priv;
}

struct UpClientClass
{
	GObjectClass parentClass;
	/** */
	extern(C) void function(UpClient* client, UpDevice* device) deviceAdded;
	/** */
	extern(C) void function(UpClient* client, const(char)* objectPath) deviceRemoved;
	/** */
	extern(C) void function() UpClientReserved1;
	/** */
	extern(C) void function() UpClientReserved2;
	/** */
	extern(C) void function() UpClientReserved3;
	/** */
	extern(C) void function() UpClientReserved4;
	/** */
	extern(C) void function() UpClientReserved5;
	/** */
	extern(C) void function() UpClientReserved6;
	/** */
	extern(C) void function() UpClientReserved7;
	/** */
	extern(C) void function() UpClientReserved8;
}

/**
 * Private #UpClient data
 */
struct UpClientPrivate;

struct UpDevice
{
	GObject parent;
	UpDevicePrivate* priv;
}

struct UpDeviceClass
{
	GObjectClass parentClass;
	/** */
	extern(C) void function() UpDeviceReserved1;
	/** */
	extern(C) void function() UpDeviceReserved2;
	/** */
	extern(C) void function() UpDeviceReserved3;
	/** */
	extern(C) void function() UpDeviceReserved4;
	/** */
	extern(C) void function() UpDeviceReserved5;
	/** */
	extern(C) void function() UpDeviceReserved6;
	/** */
	extern(C) void function() UpDeviceReserved7;
	/** */
	extern(C) void function() UpDeviceReserved8;
}

/**
 * Private #PkDevice data
 */
struct UpDevicePrivate;

struct UpHistoryItem
{
	GObject parent;
	UpHistoryItemPrivate* priv;
}

struct UpHistoryItemClass
{
	GObjectClass parentClass;
}

struct UpHistoryItemPrivate;

struct UpStatsItem
{
	GObject parent;
	UpStatsItemPrivate* priv;
}

struct UpStatsItemClass
{
	GObjectClass parentClass;
}

struct UpStatsItemPrivate;

struct UpWakeupItem
{
	GObject parent;
	UpWakeupItemPrivate* priv;
}

struct UpWakeupItemClass
{
	GObjectClass parentClass;
}

struct UpWakeupItemPrivate;

struct UpWakeups
{
	GObject parent;
	UpWakeupsPrivate* priv;
}

struct UpWakeupsClass
{
	GObjectClass parentClass;
	/** */
	extern(C) void function(UpWakeups* wakeups) dataChanged;
	/** */
	extern(C) void function(UpWakeups* wakeups, uint value) totalChanged;
}

struct UpWakeupsPrivate;

enum MAJOR_VERSION = 0;
alias UP_MAJOR_VERSION = MAJOR_VERSION;

/**
 * The compile-time micro version
 */
enum MICRO_VERSION = 7;
alias UP_MICRO_VERSION = MICRO_VERSION;

enum MINOR_VERSION = 99;
alias UP_MINOR_VERSION = MINOR_VERSION;
