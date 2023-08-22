import 'dart:convert';

import 'player.dart';

/// A class to represent a game, with players and a current player
class Game {
  /// The list of players for the game
  final List<Player> players;

  /// The index of the current player
  int _currentPlayerIndex;

  Game({required this.players, int currentPlayerIndex = 0})
      : _currentPlayerIndex = currentPlayerIndex;

  Map<String, dynamic> toJson() {
    return {
      "players": jsonEncode(players.map((player) => player.toJson()).toList()),
      "currentPlayerIndex": _currentPlayerIndex,
    };
  }

  Game.fromJson(Map<String, dynamic> json)
      : players = (jsonDecode(json["players"]) as List)
            .map((player) => Player.fromJson(player))
            .toList(),
        _currentPlayerIndex = json["currentPlayerIndex"];

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
