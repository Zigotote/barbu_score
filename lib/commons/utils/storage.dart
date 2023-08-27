import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/contract_info.dart';
import '../models/domino_points_props.dart';
import '../models/game.dart';
import 'globals.dart' as globals;

/// A class to handle local storage objects
class MyStorage {
  static const _settingsBoxName = "settings";
  static const _gameBoxName = "game";

  static const String _gameKey = "game";
  static const String _isDarkThemeKey = "isDarkTheme";

  MyStorage._();

  /// The function to call to init storage
  static init() async {
    await Hive.initFlutter();
    await Hive.openBox(_gameBoxName);
    await Hive.openBox(_settingsBoxName);
    Hive.registerAdapter(GameAdapter());
    Hive.registerAdapter(PlayerAdapter());
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(BarbuContractModelAdapter());
    Hive.registerAdapter(NoLastTrickContractModelAdapter());
    Hive.registerAdapter(NoHeartsContractModelAdapter());
    Hive.registerAdapter(NoQueensContractModelAdapter());
    Hive.registerAdapter(NoTricksContractModelAdapter());
    Hive.registerAdapter(TrumpsContractModelAdapter());
    Hive.registerAdapter(DominoContractModelAdapter());
  }

  /// Gets the game saved in the store
  static Game? getStoredGame() {
    var storedGame = Hive.box(_gameBoxName).get(_gameKey);
    if (storedGame != null) {
      // If the game is finished but not removed from storage it shouldn't be loaded
      if (storedGame.isFinished) {
        Hive.box(_gameBoxName).delete(_gameKey);
        return null;
      }
      globals.nbPlayers = storedGame.players.length;
      return storedGame;
    }
    return null;
  }

  /// Saves the game status
  static void saveGame(Game game) {
    try {
      Hive.box(_gameBoxName).put(_gameKey, game);
    } catch (_) {}
  }

  /// Saves true if app theme should be dark, false otherwise
  static void saveIsDarkTheme(bool isDarkTheme) {
    Hive.box(_settingsBoxName).put(_isDarkThemeKey, isDarkTheme);
  }

  /// Returns true if saved theme is dark, false if it is white and null if nothing is saved
  static bool? getIsDarkTheme() {
    return Hive.box(_settingsBoxName).get(_isDarkThemeKey);
  }

  /// Gets the points associated to this contract. Returns default points if no personalized data saved
  static int getPoints(ContractsInfo contractsInfo) {
    // TODO Océane créer la classe pour conserver les paramètres de chaque contrat
    // Brancher ça ssur Hive
    // Et le brancher dans les écrans
    return /*_storage?.getInt(contractsInfo.name) ??*/ contractsInfo
        .defaultPoints;
  }

  /// Saves the points associated to domino contract
  static DominoPointsProps getDominoPoints() {
    /*final bool? isFix = _storage?.getBool(MyStorage._dominoIsFix);
    final List<int>? points = _storage
        ?.getStringList(MyStorage._dominoPoints)
        ?.map((e) => int.parse(e))
        .toList();
    if (isFix != null && points != null) {
      return DominoPointsProps(isFix: isFix, points: points);
    }*/
    return ContractsInfo.domino.defaultPoints;
  }

  /// Saves the points associated to this contract
  /// Do not use this method for domino scores
  static void savePoints(ContractsInfo contractsInfo, int points) {
    //_storage?.setInt(contractsInfo.name, points);
  }

  /// Saves the points associated to domino contract
  static void saveDominoPoints(DominoPointsProps props) {
    /*_storage?.setBool(MyStorage._dominoIsFix, props.isFix);
    _storage?.setStringList(
      MyStorage._dominoPoints,
      props.points.map((point) => point.toString()).toList(),
    )*/
  }

  /// Deletes the data saved for the game in the store
  static void deleteGame() {
    globals.nbPlayers = 0;
    Hive.box(_gameBoxName).clear();
  }
}
