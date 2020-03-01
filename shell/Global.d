module Global;
public import MultiMonitor;
public import NotificationServer;
public import PanelManager;
public import Wallpaper;
public import WindowManager;

__gshared NotificationServer notifSrv;
__gshared WindowManager winMgr;
__gshared MultiMonitorRunner!PanelManager panelMgr;
__gshared MultiMonitorRunner!Wallpaper wallpaper;
