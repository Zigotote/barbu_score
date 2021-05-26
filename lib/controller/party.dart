import 'dart:collection';

import 'package:get/get.dart';

import 'player.dart';

/// A party with some players
class PartyController extends GetxController {
  static const int NB_PLAYERS_MIN = 4;
  static const int NB_PLAYERS_MAX = 6;

  /// The list of the players for this party
  RxList<PlayerController> _players;

  /// The index of the current player
  int _currentPlayerIndex;

  PartyController() {
    this._players = List.generate(
      4,
      (index) => PlayerController(index),
      growable: true,
    ).obs;
    _currentPlayerIndex = 0;
  }

  /// Returns the player list
  UnmodifiableListView<PlayerController> get players =>
      UnmodifiableListView(_players);

  /// Returns the number of players for the party
  int get nbPlayers => _players.length;

  /// Returns the current player
  PlayerController get currentPlayer => _players[_currentPlayerIndex];

  /// Adds a player to the party
  void addPlayer() {
    _players.add(PlayerController(_players.last.id + 1));
  }

  /// Removes the player at the given index from the party
  void removePlayer(int index) {
    _players.removeAt(index);
  }

  /// Changes the current player to the next one
  /// Returns true if the player has successly been changed, false if it is the end of the party
  bool nextPlayer() {
    _currentPlayerIndex++;
    if (_currentPlayerIndex == this.nbPlayers) {
      _currentPlayerIndex = 0;
    }
    return this.currentPlayer.availableContracts.length > 0;
  }
}
