import 'dart:ui';

import 'package:hive_flutter/adapters.dart';

import '../models/contract_info.dart';
import '../models/contract_models.dart';
import '../models/contract_settings_models.dart';
import '../models/game.dart';
import '../models/player.dart';
import 'globals.dart' as globals;
import 'screen.dart';

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
    Hive.registerAdapter<Game>(GameAdapter());
    Hive.registerAdapter<Player>(PlayerAdapter());
    Hive.registerAdapter<Color>(ColorAdapter());
    Hive.registerAdapter<ContractsInfo>(ContractsInfoAdapter());
    Hive.registerAdapter<BarbuContractModel>(BarbuContractModelAdapter());
    Hive.registerAdapter<NoLastTrickContractModel>(
        NoLastTrickContractModelAdapter());
    Hive.registerAdapter<NoHeartsContractModel>(NoHeartsContractModelAdapter());
    Hive.registerAdapter<NoQueensContractModel>(NoQueensContractModelAdapter());
    Hive.registerAdapter<NoTricksContractModel>(NoTricksContractModelAdapter());
    Hive.registerAdapter<TrumpsContractModel>(TrumpsContractModelAdapter());
    Hive.registerAdapter<DominoContractModel>(DominoContractModelAdapter());
    Hive.registerAdapter<PointsContractSettings>(
        PointsContractSettingsAdapter());
    Hive.registerAdapter<IndividualScoresContractSettings>(
        IndividualScoresContractSettingsAdapter());
    Hive.registerAdapter<TrumpsContractSettings>(
        TrumpsContractSettingsAdapter());
    Hive.registerAdapter<DominoContractSettings>(
        DominoContractSettingsAdapter());

    await Hive.openBox(_gameBoxName);
    await Hive.openBox(_settingsBoxName);
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

  /// Deletes the data saved for the game in the store
  static void deleteGame() {
    globals.nbPlayers = 0;
    Hive.box(_gameBoxName).clear();
  }

  /// Returns true if saved theme is dark, false if it is white. If nothing saved, return platform brightness
  static bool getIsDarkTheme() {
    return Hive.box(_settingsBoxName).get(_isDarkThemeKey,
        defaultValue: ScreenHelper.brightness == Brightness.dark);
  }

  /// Saves true if app theme should be dark, false otherwise
  static void saveIsDarkTheme(bool isDarkTheme) {
    Hive.box(_settingsBoxName).put(_isDarkThemeKey, isDarkTheme);
  }

  /// Gets the settings associated to this contract. Returns default settings if no personalized data saved
  static T? getSettings<T>(ContractsInfo contractsInfo) {
    return Hive.box(_settingsBoxName)
        .get(contractsInfo.name, defaultValue: contractsInfo.settings);
  }

  /// Saves the points associated to this contract
  static void saveSettings(
      ContractsInfo contractsInfo, AbstractContractSettings settings) {
    Hive.box(_settingsBoxName).put(contractsInfo.name, settings);
  }
}
