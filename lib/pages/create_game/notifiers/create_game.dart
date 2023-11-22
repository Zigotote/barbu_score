import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/player.dart';
import '../../../commons/models/player_colors.dart';
import '../../../commons/utils/globals.dart';
import '../../../commons/utils/player_icon_properties.dart';

final createGameProvider =
    ChangeNotifierProvider.autoDispose<CreateGameNotifier>(
  (ref) => CreateGameNotifier(),
);

class CreateGameNotifier with ChangeNotifier {
  /// The list of players for the game
  final List<Player> _players;

  CreateGameNotifier()
      : _players = List.generate(
          4,
          (index) => Player(
            color: PlayerIconProperties.playerColors[index],
            image: PlayerIconProperties.playerImages[index],
          ),
          growable: true,
        );

  UnmodifiableListView<Player> get players => UnmodifiableListView(_players);

  /// Adds a player for the game
  void addPlayer() {
    _players.add(Player(
      color: PlayerIconProperties.playerColors[_players.length],
      image: PlayerIconProperties.playerImages[_players.length],
    ));
    notifyListeners();
  }

  /// Removes the player from the list
  void removePlayer(Player player) {
    _players.remove(player);
    notifyListeners();
  }

  /// Moves a player from oldIndex to newIndex
  void movePlayer(int oldIndex, int newIndex) {
    Player player = _players.removeAt(oldIndex);
    _players.insert(newIndex, player);
    notifyListeners();
  }

  /// Returns the first letter of each player who choose this color
  String getPlayersWithColor(PlayerColors color) {
    return _players
        .where((player) => player.color == color)
        .map((player) => player.name.trim().isEmpty
            ? "X"
            : player.name.trim().characters.first.toUpperCase())
        .join("/");
  }

  void changePlayerColor(Player player, PlayerColors color) {
    _players.firstWhere((p) => p == player).color = color;
    notifyListeners();
  }

  void changePlayerImage(Player player, String image) {
    _players.firstWhere((p) => p == player).image = image;
    notifyListeners();
  }

  /// Returns if the number of player is valid to start a game
  bool get isValid =>
      _players.length >= kNbPlayersMin && _players.length <= kNbPlayersMax;

  String? playerValidator(Player player) {
    if (player.name.trim().isEmpty) {
      return "Indiquer un nom.";
    } else if (_isDuplicateName(player)) {
      return "Nom déjà pris.";
    } else if (_isDuplicateColor(player)) {
      return "Couleur déjà prise.";
    }
    return null;
  }

  /// Returns true if the player has the same name than another
  bool _isDuplicateName(Player player) {
    return _players.any((p) => p != player && p.name.trim() == player.name);
  }

  /// Returns true if the player has the color name than another
  bool _isDuplicateColor(Player player) {
    return _players.any((p) => p != player && p.color == player.color);
  }
}
