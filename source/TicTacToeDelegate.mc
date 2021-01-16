using Toybox.WatchUi;
using Toybox.System;

class TicTacToeDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        WatchUi.pushView(new GameView(), new GameDelegate(), WatchUi.SLIDE_UP);
    }

}
