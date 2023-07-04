import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.dart';
import 'globals.dart' as globals;

/// A class to handle local storage objects
class MyStorage {
  static const String _gameKey = "game";

  /// The accessor for storage
  static SharedPreferences? _storage;

  factory MyStorage() => MyStorage._();

  MyStorage._();

  /// The function to call to init storage
  init() async {
    _storage ??= await SharedPreferences.getInstance();
  }

  /// Gets the game saved in the store
  Game? getStoredGame() {
    var storedGame = _storage?.getString(_gameKey);
    if (storedGame != null) {
      final Game game = Game.fromJson(jsonDecode(storedGame));
      globals.nbPlayers = game.players.length;
      return game;
    }
    return null;
  }

  /// Saves the game status
  void saveGame(Game game) {
    try {
      _storage?.setString(_gameKey, jsonEncode(game.toJson()));
    } catch (_) {}
  }

  /// Deletes the data saved in the store
  void delete() {
    _storage?.clear();
  }
}
