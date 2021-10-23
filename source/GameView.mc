using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Math;

class GameView extends Ui.View {
	var Storage = App.Storage;

	function initialize() {
		View.initialize();
	}

	// Load your resources here
	function onLayout(dc) {
		setLayout(Rez.Layouts.GameLayout(dc));
	}

	// Update the view
	function onUpdate(dc) {
		// Call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);

		if (Storage.getValue("startGame")) {
			// Radius and percent for x/y position
	   		var r = percentInPx(8);
	   		var xy = [30, 60, 90];
			dc.setPenWidth(3);
			// Draw board
			var board = Storage.getValue("board");
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
			for (var i=0; i<9; i++) {
				if (board[i] != 0) {
					var x = percentInPx(xy[i%3]);
					var y = percentInPx(xy[Math.floor(i/3)]);
					if (board[i] == 1) {
						dc.drawCircle(x, y, r);
					} else {
						dc.drawLine(x-r, y-r, x+r, y+r);
						dc.drawLine(x-r, y+r, x+r, y-r);
					}
				}
			}

			if (Storage.getValue("gameEnd") == -1) {
				// Set x, y
				var pos = Storage.getValue("marker")[0];
		   		var x = xy[pos%3];
		   		var y = xy[Math.floor(pos/3)];
				// Draw new Marker
				dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
				x = percentInPx(x);
				y = percentInPx(y);
				if (Storage.getValue("marker")[1] == 1) {
					dc.drawCircle(x, y, r);
				} else {
					dc.drawLine(x-r, y-r, x+r, y+r);
					dc.drawLine(x-r, y+r, x+r, y-r);
				}
			} else {
				dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
				var text = Lang.format(Ui.loadResource(Rez.Strings.won), [Storage.getValue("gameEnd")]);
				if (Storage.getValue("mode") != 0 && Storage.getValue("gameEnd") == 2) {
					text = Ui.loadResource(Rez.Strings.garmin_won);
				}
				if (Storage.getValue("gameEnd") == 0) {
					text = Ui.loadResource(Rez.Strings.tie);
				}
				var center = Sys.getDeviceSettings().screenWidth/2;
				dc.drawText(center, center, Gfx.FONT_LARGE, text, Gfx.TEXT_JUSTIFY_CENTER);
			}
		}
	}

	function percentInPx(percent) {
		return Sys.getDeviceSettings().screenWidth / 100 * percent;
	}

}
