using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class GameDelegate extends Ui.BehaviorDelegate {
	var Storage = App.Storage;
	var player = 1;
	var playerPos = 0;
	var board = [0,0,0,0,0,0,0,0,0];

	function initialize() {
		BehaviorDelegate.initialize();
		Storage.setValue("marker", [playerPos, player]);
		Storage.setValue("board", board);
		Storage.setValue("gameEnd", -1);
		Storage.setValue("startGame", true);
		Ui.requestUpdate();
	}

	function onSelect() {
		board[playerPos] = player;
		Storage.setValue("board", board);
		Storage.setValue("gameEnd", isGameEnd());
		player = player==1 ? 2 : 1;
		playerPos = 0;
		if (isBesetzt() && isGameEnd() == -1) {
			onNextPage();
		} else {
			Storage.setValue("marker", [playerPos,player]);
		}
		Ui.requestUpdate();
	}

	function onPreviousPage() {
   		playerPos = playerPos==0 ? 8 : playerPos-1;
		if (isBesetzt()) {
			onPreviousPage();
		} else {
			updateMarker();
		}
	}

	function onNextPage() {
		playerPos = playerPos==8 ? 0 : playerPos+1;
		if (isBesetzt()) {
			onNextPage();
		} else {
			updateMarker();
		}
	}

	function isBesetzt() {
		return board[playerPos] != 0;
	}

	function updateMarker() {
		Storage.setValue("marker", [playerPos,player]);
		Ui.requestUpdate();
	}

	function isGameEnd() {
		var isGameEnd = -1;
		for (var p=1; p<3; p++) {
			for (var i=0; i<3; i++) {
				// Horizontal
				if (board[i*3] == p && board[i*3+1] == p && board[i*3+2] == p) {
					isGameEnd = p;
				}
				// Vertical
				if (board[i] == p && board[i+3] == p && board[i+6] == p) {
					isGameEnd = p;
				}
			}
			// Diagonal
			if (board[0] == p && board[4] == p && board[8] == p ||
				board[2] == p && board[4] == p && board[6] == p) {
				isGameEnd = p;
			}
		}
		// Unentschieden
		if (isGameEnd == -1) {
			isGameEnd = 0;
			for (var i=0; i<9; i++) {
				if (board[i] == 0) {
					isGameEnd = -1;
				}
			}
		}
		return isGameEnd;
	}

}
