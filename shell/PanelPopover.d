module PanelPopover;
import gtk.Widget;
import gtk.Popover;
import gtk.ToggleButton;
import lsh.LayerShell;
import Panel;

final class PanelPopover {
	Popover popover;
	Panel panel;
	ToggleButton btn;

	this(ToggleButton btn_, Panel panel_) {
		btn = btn_;
		panel = panel_;
		popover = new Popover(btn);
		popover.setSizeRequest(420, 420);
		popover.addOnHide(&deactivate);
		btn.addOnToggled(&activate);
	}

	void activate(ToggleButton _) {
		if (!btn.getActive()) {
			return deactivate(btn);
		}
		if (panel.activePopover && panel.activePopover != this) {
			panel.activePopover.popover.hide();
		}
		LayerShell.setKeyboardInteractivity(panel.toplevel, true);
		btn.setActive(true);
		popover.showAll();
		panel.activePopover = this;
	}

	void deactivate(Widget _) {
		btn.setActive(false);
		LayerShell.setKeyboardInteractivity(panel.toplevel, false);
		panel.activePopover = null;
	}
}
