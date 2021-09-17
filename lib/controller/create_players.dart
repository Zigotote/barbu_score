import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';

import 'player.dart';

/// A party with some players
class CreatePlayersController extends GetxController {
  static const int NB_PLAYERS_MIN = 4;
  static const int NB_PLAYERS_MAX = 6;

  /// Available colors for the players
  static final List<Color> colors = [
    Colors.brown.shade700,
    Colors.lightGreen.shade700,
    Colors.yellow.shade800,
    Colors.orange.shade800,
    Colors.deepOrange.shade900,
    Colors.teal.shade900,
  ];

  static final String playerImage = "assets/players/player%s.png";

  /// The list of the players for this party
  RxList<PlayerController> _players;

  CreatePlayersController() {
    this._players = List.generate(
      4,
      (index) => PlayerController(
        index,
        colors[index],
        sprintf(playerImage, [index + 1]),
      ),
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
    _players.add(PlayerController(
      _players.last.id + 1,
      colors[this.nbPlayers],
      sprintf(playerImage, [this.nbPlayers + 1]),
    ));
  }

  /// Removes the player at the given index from the party
  void removePlayer(PlayerController player) {
    _players.remove(player);
  }
}
