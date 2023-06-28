import 'dart:collection';

import 'package:barbu_score/theme/my_themes.dart';
import 'package:barbu_score/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sprintf/sprintf.dart';

import '../../../models/player.dart';
import '../create_game_props.dart';

final createGameProvider =
    ChangeNotifierProvider.autoDispose<CreateGameNotifier>(
  (ref) => CreateGameNotifier(
      ref.watch(appThemeProvider).theme.colorScheme.playerColors),
);

class CreateGameNotifier with ChangeNotifier {
  /// The available colors for the players (depending on app theme)
  final List<Color> playerColors;

  /// The list of players for the game
  List<Player> _players;

  CreateGameNotifier(this.playerColors)
      : _players = List.generate(
          4,
          (index) => Player(
            color: playerColors[index],
            image: sprintf(kPlayerImageFolder, [index + 1]),
          ),
          growable: true,
        );

  UnmodifiableListView<Player> get players => UnmodifiableListView(_players);

  /// Adds a player for the game
  void addPlayer() {
    _players.add(Player(
      color: playerColors[_players.length],
      image: sprintf(kPlayerImageFolder, [_players.length + 1]),
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
  String getPlayersWithColor(Color color) {
    return _players
        .where((player) => player.color == color)
        .map((player) => player.name.trim().isEmpty
            ? "X"
            : player.name.trim().characters.first.toUpperCase())
        .join("/");
  }

  void changePlayerColor(Player player, Color color) {
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
    return this._players.any((p) => p != player && p.color == player.color);
  }
}
