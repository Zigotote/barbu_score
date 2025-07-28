import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'contract_info.dart';
import 'player.dart';

/// A class to represent a game, with players and a current player
class Game {
  final DateTime startDate;

  /// The list of players for the game
  final List<Player> players;

  /// The index of the current player
  int _currentPlayerIndex;

  /// The indicator to know if game is finished or not
  bool isFinished;

  Game({required this.players})
      : startDate = DateTime.now(),
        _currentPlayerIndex = 0,
        isFinished = false;

  Game.fromJson(Map<String, dynamic> json)
      :
        // Temporary to save old games without date
        startDate = json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : DateTime.now(),
        players = (jsonDecode(json["players"]) as List)
            .map((player) => Player.fromJson(player))
            .toList(),
        _currentPlayerIndex = json["currentPlayerIndex"],
        isFinished = json["isFinished"];

  Map<String, dynamic> toJson() {
    return {
      "startDate": startDate.toString(),
      "players": jsonEncode(players.map((player) => player.toJson()).toList()),
      "currentPlayerIndex": _currentPlayerIndex,
      "isFinished": isFinished
    };
  }

  @visibleForTesting
  set currentPlayerIndex(int value) => _currentPlayerIndex = value;

  /// Returns the current player
  Player get currentPlayer => players[_currentPlayerIndex];

  /// Changes the current player to the next one
  void nextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == players.length) {
      _currentPlayerIndex = 0;
    }
  }

  /// Returns the name of the players who played this contract
  List<String> getPlayersWithPlayedContract(ContractsInfo contract) {
    return players
        .where((player) => player.hasPlayedContract(contract))
        .map((player) => player.name)
        .toList();
  }

  @override
  String toString() {
    return players.toString();
  }
}
