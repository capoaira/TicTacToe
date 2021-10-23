using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Timer;

class _Game1vsPCDelegate extends Ui.BehaviorDelegate {
	var Storage = App.Storage;
	hidden var board;
	hidden var winner;
	hidden var activePlayer;
	hidden var playerPos;

	function initialize() {
		BehaviorDelegate.initialize();

		board = [0,0,0,0,0,0,0,0,0];
		playerPos = 0;
		activePlayer = Storage.getValue("starter");

		Storage.setValue("marker", [playerPos, activePlayer]);
		Storage.setValue("board", board);
		Storage.setValue("gameEnd", -1);
		Storage.setValue("startGame", true);
		Ui.requestUpdate();
		
		if (activePlayer == 2) {
			computerMove(board, activePlayer);
		}
		Ui.requestUpdate();
	}

	function onSelect() {
		if (activePlayer == 1) {
			setMarker(playerPos);
		}
	}

	function onPreviousPage() {
		if (activePlayer == 1) {
			playerPos = playerPos==0 ? 8 : playerPos-1;
			if (isBesetzt()) {
				onPreviousPage();
			} else {
				updateMarker();
			}
		}
	}

	function onNextPage() {
		if (activePlayer == 1) {
			playerPos = playerPos==8 ? 0 : playerPos+1;
			if (isBesetzt()) {
				onNextPage();
			} else {
				updateMarker();
			}
		}
	}

	function setMarker(f) {
		board[f] = activePlayer;
		Storage.setValue("board", board);
		Storage.setValue("gameEnd", isGameEnd());
		activePlayer = activePlayer==1 ? 2 : 1;
		playerPos = 0;
		if (isBesetzt() && isGameEnd() == -1) {
			onNextPage();
		} else {
			Storage.setValue("marker", [playerPos,activePlayer]);
		}
		Ui.requestUpdate();

		if (activePlayer == 2 && isGameEnd() == -1) {
			computerMove(board, activePlayer);
		}
	}

	function movesLeft(tempBoard) {
		var movesLeft = 0;
		for (var i=0; i<9; i++) {
			if (tempBoard[i] == 0)  {
				movesLeft++;
			}
		}
		return movesLeft;
	}

	function getEnemy(p) {
		return p==1 ? 2 : 1;
	}

	function checkWin(tempBoard) {
		var winner = 0;
		for (var p=1; p<3; p++) {
			for (var i=0; i<3; i++) {
				// Horizontal
				if (tempBoard[i*3] == p && tempBoard[i*3+1] == p && tempBoard[i*3+2] == p) {
					winner = p;
				}
				// Vertical
				if (tempBoard[i] == p && tempBoard[i+3] == p && tempBoard[i+6] == p) {
					winner = p;
				}
			}
			// Diagonal
			if (tempBoard[0] == p && tempBoard[4] == p && tempBoard[8] == p ||
				tempBoard[2] == p && tempBoard[4] == p && tempBoard[6] == p) {
				winner = p;
			}
		}
		return winner;
	}

	function alphabeta(tempBoard, player, treeDepth, alpha, beta) {
		System.println("alphabeta");
		var tempWinner = checkWin(tempBoard);
		if (movesLeft(tempBoard) == 0 || tempWinner || treeDepth == 0) {
			if (tempWinner == getEnemy(activePlayer)) {
				return -1;
			}
			if (tempWinner == 0) {
				return 0;
			}
			if (tempWinner == activePlayer) {
				return 1;
			}
			return -2;
		}
		treeDepth--;
		for (var i=0; i<9; i++) {
			if (tempBoard[i] == 0) {
				tempBoard[i] = player;
				var results = alphabeta(tempBoard, getEnemy(player), treeDepth, -2, 2);
				tempBoard[i] = 0;
				if (player == activePlayer) {
					if (results > alpha) {
						alpha = results;
					}
            		if (alpha >= beta) {
						return beta;
					}
				} else {
					if (results < beta) {
						beta = results;
					}
            		if (beta <= alpha) {
						return alpha;
					}
				}
			}
		}
		if (player == activePlayer) {
			return alpha;
		} else {
			return beta;
		}
	}

	function computerMove(tempBoard, player) {
		var result;
		var bestMove = -2;

		if (movesLeft(tempBoard) == 9) {
			setMarker(4);
			return;
		}

		var choices = [];

		for (var i=0; i<9; i++) {
			if (tempBoard[i] == 0) {
				tempBoard[i] = player;
				var results = alphabeta(tempBoard, getEnemy(player), -1, -2, 2);
				tempBoard[i] = 0;
				if (results > bestMove) {
					bestMove = results;
					choices = [];
					choices.add(i);
				} else if (results == bestMove)  {
					choices.add(i);
				}
			}
		}
		// ToDo: Shuffle List
		setMarker(choices[0]);
	}

	function isBesetzt() {
		return board[playerPos] != 0;
	}

	function updateMarker() {
		Storage.setValue("marker", [playerPos,activePlayer]);
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
		if (isGameEnd == -1 && movesLeft(board) == 0) {
			isGameEnd = 0;
		}
		return isGameEnd;
	}
	
	function timerCallback() {
		return true;
    }

}
