using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application as App;
using Toybox.System;

class GameView extends WatchUi.View {
    var Storage = App.Storage;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.GameLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        if (Storage.getValue("initialize")) {
	        // Radius and percent for x/y position
       		var r = percentInPx(8);
       		var xy = [30, 60, 90];
	        dc.setPenWidth(3);
	        // Draw feld
	        var feld = Storage.getValue("feld");
	        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
	        for (var x=0; x<3; x++) {
			   for (var y=0; y<3; y++) {
				    if (feld[x][y][0]) {
						var locX = percentInPx(xy[x]);
						var locY = percentInPx(xy[y]);
				    	if (feld[x][y][1] == 1) {
				    		dc.drawCircle(locX, locY, r);
				    	} else {
				    		dc.drawLine(locX-r, locY-r, locX+r, locY+r);
				    		dc.drawLine(locX-r, locY+r, locX+r, locY-r);
				    	}
				    }
				}
			}

			if (!Storage.getValue("gameEnd")[0]) {
	    		// Set x, y
	       		var x = xy[Storage.getValue("marker")[0]];
	       		var y = xy[Storage.getValue("marker")[1]];
		    	// Draw new Marker
		        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
		        x = percentInPx(x);
		        y = percentInPx(y);
		    	if (Storage.getValue("marker")[2] == 1) {
		    		dc.drawCircle(x, y, r);
		    	} else {
		    		dc.drawLine(x-r, y-r, x+r, y+r);
		    		dc.drawLine(x-r, y+r, x+r, y-r);
		    	}
		    } else {
		    	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		    	var text = Lang.format(WatchUi.loadResource(Rez.Strings.won), [Storage.getValue("gameEnd")[1]]);
		    	if (Storage.getValue("gameEnd")[1] == 0) {
		    		text = WatchUi.loadResource(Rez.Strings.tie);
		    	}
		    	var center = System.getDeviceSettings().screenWidth/2;
		    	dc.drawText(center, center, Graphics.FONT_LARGE, text, Graphics.TEXT_JUSTIFY_CENTER);
		    }
	    }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
    function percentInPx(percent) {
    	return System.getDeviceSettings().screenWidth / 100 * percent;
    }

}
