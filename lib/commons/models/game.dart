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

  Game({required this.players, int currentPlayerIndex = 0})
      : _currentPlayerIndex = currentPlayerIndex;

  /// Returns the current player
  Player get currentPlayer => players[_currentPlayerIndex];

  /// Returns true if the game is finished
  bool get isFinished => currentPlayer.availableContracts.isEmpty;

  /// Changes the current player to the next one
  nextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == players.length) {
      _currentPlayerIndex = 0;
    }
  }
}
