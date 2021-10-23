using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class TicTacToeView extends Ui.View {
	var Storage = App.Storage;

	function initialize() {
		View.initialize();
	}

	// Load your resources here
	function onLayout(dc) {
		setLayout(Rez.Layouts.MainLayout(dc));
	}

	// Update the view
	function onUpdate(dc) {
		// Call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);

		var text = Ui.loadResource(Rez.Strings.mode_0);
		if (Storage.getValue("mode") == 1) {
			text = Ui.loadResource(Rez.Strings.mode_1);
		}
		if (Storage.getValue("mode") == 2) {
			text = Ui.loadResource(Rez.Strings.mode_2);
		}
		if (Storage.getValue("mode") == 3) {
			text = Ui.loadResource(Rez.Strings.mode_3);
		}
		dc.drawText(percentInPx(10), percentInPx(50), Gfx.FONT_XTINY, text, Gfx.TEXT_JUSTIFY_LEFT);

		if (Storage.getValue("mode") != 0) {
			text = Ui.loadResource(Rez.Strings.player_First);
			if (Storage.getValue("starter") == 2) {
				text = Ui.loadResource(Rez.Strings.garmin_First);
			}
			dc.drawText(percentInPx(10), percentInPx(75), Gfx.FONT_XTINY, text, Gfx.TEXT_JUSTIFY_LEFT);
		}
	}

	function percentInPx(percent) {
		return Sys.getDeviceSettings().screenWidth / 100 * percent;
	}

}
