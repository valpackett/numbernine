module PanelManager;
import gio.Settings;
import Panel;

final class PanelManager {
	Settings settings;
	Panel[string] panels;

	this() {
		settings = new Settings("technology.unrelenting.numbernine.Shell");
		settings.addOnChanged((string key, Settings _) {
			if (key == "panels")
				updatePanels();
		});
		updatePanels();
	}

	void updatePanels() {
		import std.algorithm : canFind;

		auto panelNames = settings.getStrv("panels");
		if (panelNames.length == 0) {
			panelNames = ["default"];
			settings.setStrv("panels", panelNames);
		}
		foreach (name; panelNames) {
			if ((name in panels) is null) {
				panels[name] = new Panel(name);
				panels[name].toplevel.showAll();
			}
		}
		foreach (name, _; panels) {
			if (!panelNames.canFind(name)) {
				panels.remove(name);
			}
		}
	}
}
