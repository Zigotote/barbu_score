import 'package:hive/hive.dart';

import 'player.dart';

part 'game.g.dart';

/// A class to represent a game, with players and a current player
@HiveType(typeId: 0)
class Game {
  /// The list of players for the game
  @HiveField(0)
  final List<Player> players;

  /// The index of the current player
  @HiveField(1)
  int _currentPlayerIndex;

  /// The indicator to know if game is finished or not
  @HiveField(2)
  bool isFinished;

  Game({required this.players, int currentPlayerIndex = 0})
      : _currentPlayerIndex = currentPlayerIndex,
        isFinished = false;

  /// Returns the current player
  Player get currentPlayer => players[_currentPlayerIndex];

  /// Changes the current player to the next one
  nextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == players.length) {
      _currentPlayerIndex = 0;
    }
  }

  // coverage:ignore-start
  @override
  String toString() {
    return players.toString();
  }
// coverage:ignore-end
}
