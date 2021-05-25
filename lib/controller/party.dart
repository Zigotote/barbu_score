import 'dart:collection';

import 'package:get/get.dart';

import 'player.dart';

/// A party with some players
class PartyController extends GetxController {
  static const int NB_PLAYERS_MIN = 4;
  static const int NB_PLAYERS_MAX = 6;

  /// The list of the players for this party
  RxList<PlayerController> _players;

  PartyController() {
    this._players = List.generate(
      4,
      (index) => PlayerController(index),
      growable: true,
    ).obs;
  }

  /// Returns the player list
  UnmodifiableListView<PlayerController> get players =>
      UnmodifiableListView(_players);

  /// Returns the number of players for the party
  int get nbPlayers => _players.length;

  /// Adds a player to the party
  void addPlayer() {
    _players.add(PlayerController(_players.last.id + 1));
  }

  /// Removes the player at the given index from the party
  void removePlayer(int index) {
    _players.removeAt(index);
  }
}
