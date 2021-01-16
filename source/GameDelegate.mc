using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application as App;

class GameDelegate extends WatchUi.BehaviorDelegate {
    var Storage = App.Storage;
	var x = 0;
	var y = 0;
	var player = 1;
	var feld = [
				[
					[false, 0], [false, 0], [false, 0]
				],
				[
					[false, 0], [false, 0], [false, 0]
				],
				[
					[false, 0], [false, 0], [false, 0]
				]
			];

    function initialize() {
        BehaviorDelegate.initialize();
    	Storage.setValue("marker", [x,y,player]);
    	Storage.setValue("feld", feld);
    	Storage.setValue("gameEnd", [false, 0]);
    	Storage.setValue("initialize", true);
    	WatchUi.requestUpdate();
    }

    function onSelect() {
    	feld[x][y][0] = true;
    	feld[x][y][1] = player;
    	Storage.setValue("feld", feld);
    	Storage.setValue("gameEnd", isGameEnd());
    	player = player==1 ? 2 : 1;
		x = 0;
		y = 0;
		if (isBesetzt() && !isGameEnd()[0]) {
			onNextPage();
		} else {
    		Storage.setValue("marker", [x,y,player]);
		}
    	WatchUi.requestUpdate();
    }

    function onPreviousPage() {
   		x = x==0 ? 2 : x-1;
   		y = x==2 ? y==0 ? 2 : y-1 : y;
    	if (isBesetzt()) {
    		onPreviousPage();
    	} else {
    		updateMarker();
    	}
    }

    function onNextPage() {
    	x = x==2 ? 0 : x+1;
   		y = x==0 ? y==2 ? 0 : y+1 : y;
    	if (isBesetzt()) {
    		onNextPage();
    	} else {
    		updateMarker();
    	}
    }
    
    function isBesetzt() {
    	return feld[x][y][0];
    }
    
    function updateMarker() {
    	Storage.setValue("marker", [x,y,player]);
    	WatchUi.requestUpdate();
    }
    
    function isGameEnd() {
    	var isGameEnd = [false, 0];
    	for (var p=1; p<3; p++) {
    		System.println("p: "+p);
    		// Horizontal
	    	for (var x=0; x<3; x++) {
	    		if (feld[x][0][1] == p && feld[x][1][1] == p && feld[x][2][1] == p) {
	    			isGameEnd = [true, p];
	    		}
	    	}
	    	// Vertical
	    	for (var y=0; y<3; y++) {
	    		if (feld[0][y][1] == p && feld[1][y][1] == p && feld[2][y][1] == p) {
	    			isGameEnd = [true, p];
	    		}
	    	}
	    	// Diagonal
	    	if (feld[0][0][1] == p && feld[1][1][1] == p && feld[2][2][1] == p) {
    			isGameEnd = [true, p];
    		}
	    	if (feld[0][2][1] == p && feld[1][1][1] == p && feld[2][0][1] == p) {
    			isGameEnd = [true, p];
    		}
    	}
    	// Unentschieden
    	if (!isGameEnd[0]) {
    		isGameEnd[0] = true;
    		for (var x=0; x<3; x++) {
			   for (var y=0; y<3; y++) {
				    if (!feld[x][y][0]) {
						isGameEnd = [false, 0];
				    }
				}
			}
    	}
    	System.println(isGameEnd);
    	return isGameEnd;
    }
}
