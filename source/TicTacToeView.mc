using Toybox.WatchUi as Ui;

class TicTacToeView extends Ui.View {

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
	}

}
