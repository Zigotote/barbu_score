import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contract_info.dart';
import '../models/domino_points_props.dart';
import '../models/game.dart';
import 'globals.dart' as globals;

/// A class to handle local storage objects
class MyStorage {
  static const String _gameKey = "game";
  static const String _appThemeKey = "appTheme";
  static const String _dominoPoints = "dominoPoints";
  static const String _dominoIsFix = "dominoIsFix";

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
      // If the game is finished but not removed from storage it shouldn't be loaded
      if (game.isFinished) {
        _storage?.remove(_gameKey);
        return null;
      }
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

  /// Saves the app theme
  void saveAppTheme(ThemeMode themeMode) {
    _storage?.setString(_appThemeKey, themeMode.name);
  }

  /// Returns the app theme
  ThemeMode getAppTheme() {
    final String? appThemeName = _storage?.getString(_appThemeKey);
    return ThemeMode.values.firstWhere((theme) => theme.name == appThemeName,
        orElse: () => ThemeMode.system);
  }

  /// Gets the points associated to this contract. Returns default points if no personalized data saved
  int getPoints(ContractsInfo contractsInfo) {
    return _storage?.getInt(contractsInfo.name) ?? contractsInfo.defaultPoints;
  }

  /// Saves the points associated to domino contract
  DominoPointsProps getDominoPoints() {
    final bool? isFix = _storage?.getBool(MyStorage._dominoIsFix);
    final List<int>? points = _storage
        ?.getStringList(MyStorage._dominoPoints)
        ?.map((e) => int.parse(e))
        .toList();
    if (isFix != null && points != null) {
      return DominoPointsProps(isFix: isFix, points: points);
    }
    return ContractsInfo.domino.defaultPoints;
  }

  /// Saves the points associated to this contract
  /// Do not use this method for domino scores
  void savePoints(ContractsInfo contractsInfo, int points) {
    _storage?.setInt(contractsInfo.name, points);
  }

  /// Saves the points associated to domino contract
  void saveDominoPoints(DominoPointsProps props) {
    _storage?.setBool(MyStorage._dominoIsFix, props.isFix);
    _storage?.setStringList(
      MyStorage._dominoPoints,
      props.points.map((point) => point.toString()).toList(),
    );
  }

  /// Deletes the data saved for the game in the store
  void deleteGame() {
    globals.nbPlayers = 0;
    _storage?.remove(_gameKey);
  }
}
