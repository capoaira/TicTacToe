using Toybox.Application as App;

class TicTacToeApp extends App.AppBase {

	function initialize() {
		AppBase.initialize();
	}

	// onStart() is called on application start up
	function onStart(state) {
		Storage.setValue("startGame", false);
		Storage.setValue("mode", 0);
		Storage.setValue("starter", 1);
	}

	// onStop() is called when your application is exiting
	function onStop(state) {
		App.Storage.clearValues();
	}

	// Return the initial view of your application here
	function getInitialView() {
		return [ new TicTacToeView(), new TicTacToeDelegate() ];
	}

}
