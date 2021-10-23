using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class TicTacToeDelegate extends Ui.BehaviorDelegate {
	var Storage = App.Storage;

	function initialize() {
		BehaviorDelegate.initialize();
	}

	function onSelect() {
		var delegate = new _Game1vsPCDelegate();
		if (Storage.getValue("mode") == 0) {
			new GameDelegate();
		}
		Ui.pushView(new GameView(), delegate, Ui.SLIDE_UP);
	}

	function onPreviousPage() {
		var mode = Storage.getValue("mode");
		mode = mode==3 ? 0 : mode+1;
   		Storage.setValue("mode", mode);
		Ui.requestUpdate();
	}

	function onNextPage() {
		if (Storage.getValue("mode") != 0 ) {
			var starter = Storage.getValue("starter");
			starter = starter==1 ? 2 : 1;
			Storage.setValue("starter", starter);
			Ui.requestUpdate();
		}
	}

}
