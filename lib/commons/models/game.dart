import 'dart:convert';

import 'player.dart';

/// A class to represent a game, with players and a current player
class Game {
  /// The list of players for the game
  final List<Player> players;

  /// The index of the current player
  int currentPlayerIndex;

  Game({required this.players, this.currentPlayerIndex = 0});

  Map<String, dynamic> toJson() {
    return {
      "players": jsonEncode(players.map((player) => player.toJson()).toList()),
      "currentPlayerIndex": currentPlayerIndex,
    };
  }

  Game.fromJson(Map<String, dynamic> json)
      : players = (jsonDecode(json["players"]) as List)
            .map((player) => Player.fromJson(player))
            .toList(),
        currentPlayerIndex = json["currentPlayerIndex"];

  /// Returns the current player
  Player get currentPlayer => players[currentPlayerIndex];

  /// Changes the current player to the next one
  nextPlayer() {
    currentPlayerIndex++;
    if (currentPlayerIndex == players.length) {
      currentPlayerIndex = 0;
    }
  }
}
