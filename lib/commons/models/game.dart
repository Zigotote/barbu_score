import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'player.dart';

/// A class to represent a game, with players and a current player
class Game with EquatableMixin {
  /// The list of players for the game
  final List<Player> players;

  /// The index of the current player
  int _currentPlayerIndex;

  /// The indicator to know if game is finished or not
  bool isFinished;

  Game({required this.players, int currentPlayerIndex = 0})
      : _currentPlayerIndex = currentPlayerIndex,
        isFinished = false;

  Game.fromJson(Map<String, dynamic> json)
      : players = (jsonDecode(json["players"]) as List)
            .map((player) => Player.fromJson(player))
            .toList(),
        _currentPlayerIndex = json["currentPlayerIndex"],
        isFinished = json["isFinished"];

  Map<String, dynamic> toJson() {
    return {
      "players": jsonEncode(players.map((player) => player.toJson()).toList()),
      "currentPlayerIndex": _currentPlayerIndex,
      "isFinished": isFinished
    };
  }

  /// Returns the current player
  Player get currentPlayer => players[_currentPlayerIndex];

  /// Changes the current player to the next one
  nextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == players.length) {
      _currentPlayerIndex = 0;
    }
  }

  @override
  String toString() {
    return players.toString();
  }

  @override
  List<Object?> get props => [players, _currentPlayerIndex, isFinished];
}
