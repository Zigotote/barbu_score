import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';

import 'player.dart';

/// A party with some players
class CreatePlayersController extends GetxController {
  static const int NB_PLAYERS_MIN = 3;
  static const int NB_PLAYERS_MAX = 6;

  /// Available colors for the players in light theme
  static final List<Color> _lightColors = [
    Colors.brown.shade700,
    Colors.lightGreen.shade900,
    Colors.yellow.shade800,
    Colors.orange.shade800,
    Colors.deepOrange.shade900,
    Colors.teal.shade900,
  ];

  /// Available colors for the players in dark theme
  static final List<Color> _darkColors = [
    Colors.brown.shade400,
    Colors.lightGreen.shade800,
    Colors.yellow.shade700,
    Colors.orange.shade800,
    Colors.deepOrange.shade700,
    Colors.teal.shade400
  ];

  static final String playerImage = "assets/players/player%s.png";

  /// Returns the available colors for the players, depending on app theme
  static List<Color> get colors => Get.isDarkMode ? _darkColors : _lightColors;

  /// The list of the players for this party
  late RxList<PlayerController> _players;

  CreatePlayersController() {
    this._players = List.generate(
      4,
      (index) => PlayerController(
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

  /// Returns if the number of player is valid to start a party
  bool get isValid =>
      nbPlayers >= NB_PLAYERS_MIN && nbPlayers <= NB_PLAYERS_MAX;

  /// Returns the list of color not picked by a user
  UnmodifiableListView<Color> get availableColors =>
      UnmodifiableListView(colors.where(
        (color) => !_players.any((player) => player.color == color),
      ));

  /// Adds a player to the party
  void addPlayer() {
    _players.add(PlayerController(
      availableColors.first,
      sprintf(playerImage, [this.nbPlayers + 1]),
    ));
  }

  /// Removes the player at the given index from the party
  void removePlayer(PlayerController player) {
    _players.remove(player);
  }

  /// Moves a player from oldIndex to newIndex
  void movePlayer(int oldIndex, int newIndex) {
    PlayerController player = _players.removeAt(oldIndex);
    _players.insert(newIndex, player);
  }

  /// Returns the first letter of each player who choose this color
  String getPlayersWithColor(Color color) {
    return _players
        .where((player) => player.color == color)
        .map((player) => player.name.isEmpty
            ? "X"
            : player.name.characters.first.toUpperCase())
        .join("/");
  }

  /// Returns true if the player has the same name than another
  bool isDuplicateName(PlayerController player) {
    return _players.any((p) => p != player && p.name.trim() == player.name);
  }

  /// Returns true if the player has the color name than another
  bool isDuplicateColor(PlayerController player) {
    return this._players.any((p) => p != player && p.color == player.color);
  }
}
