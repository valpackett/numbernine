module Global;
public import MultiMonitor;
public import NotificationServer;
public import PanelManager;
public import Wallpaper;

__gshared NotificationServer notifSrv;
__gshared MultiMonitorRunner!PanelManager panelMgr;
__gshared MultiMonitorRunner!Wallpaper wallpaper;
