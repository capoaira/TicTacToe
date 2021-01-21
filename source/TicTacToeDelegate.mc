using Toybox.WatchUi as Ui;

class TicTacToeDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		BehaviorDelegate.initialize();
	}

	function onSelect() {
		Ui.pushView(new GameView(), new GameDelegate(), Ui.SLIDE_UP);
	}

}
