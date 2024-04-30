import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/contract_info.dart';
import '../models/contract_models.dart';
import '../models/contract_settings_models.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../models/player_colors.dart';
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
    Hive.registerAdapter<Game>(GameAdapter());
    Hive.registerAdapter<Player>(PlayerAdapter());
    Hive.registerAdapter<Color>(ColorAdapter());
    Hive.registerAdapter<ContractsInfo>(ContractsInfoAdapter());
    Hive.registerAdapter<OneLooserContractModel>(
        OneLooserContractModelAdapter());
    Hive.registerAdapter<MultipleLooserContractModel>(
        MultipleLooserContractModelAdapter());
    Hive.registerAdapter<TrumpsContractModel>(TrumpsContractModelAdapter());
    Hive.registerAdapter<DominoContractModel>(DominoContractModelAdapter());
    Hive.registerAdapter<OneLooserContractSettings>(
        OneLooserContractSettingsAdapter());
    Hive.registerAdapter<MultipleLooserContractSettings>(
        MultipleLooserContractSettingsAdapter());
    Hive.registerAdapter<TrumpsContractSettings>(
        TrumpsContractSettingsAdapter());
    Hive.registerAdapter<DominoContractSettings>(
        DominoContractSettingsAdapter());
    Hive.registerAdapter<PlayerColors>(PlayerColorsAdapter());

    await Hive.openBox(_gameBoxName);
    await Hive.openBox(_settingsBoxName);
  }

  /// Returns true if a game is saved in storage, false otherwise
  static bool hasStoredGame() {
    final storedGame = MyStorage.getStoredGame();
    return storedGame != null && !storedGame.isFinished;
  }

  /// Gets the game saved in the store
  static Game? getStoredGame() {
    var storedGame = Hive.box(_gameBoxName).get(_gameKey);
    if (storedGame != null) {
      globals.nbPlayers = storedGame.players.length;
      return storedGame;
    }
    return null;
  }

  /// Saves the game status
  static void saveGame(Game game) {
    Hive.box(_gameBoxName).put(_gameKey, game);
  }

  /// Deletes the data saved for the game in the store
  static void deleteGame() {
    globals.nbPlayers = 0;
    Hive.box(_gameBoxName).clear();
  }

  /// Returns true if saved theme is dark, false if it is white. If nothing saved, returns null
  static bool? getIsDarkTheme() {
    return Hive.box(_settingsBoxName).get(_isDarkThemeKey);
  }

  /// Saves true if app theme should be dark, false otherwise
  static void saveIsDarkTheme(bool isDarkTheme) {
    Hive.box(_settingsBoxName).put(_isDarkThemeKey, isDarkTheme);
  }

  /// Saves the points associated to this contract
  static void saveSettings(
      ContractsInfo contractsInfo, AbstractContractSettings settings) {
    deleteGame();
    Hive.box(_settingsBoxName).put(contractsInfo.name, settings);
  }

  /// Listens to contract settings changes
  static ValueListenable<Box> listenContractsSettings() {
    return Hive.box(_settingsBoxName).listenable(
      keys: ContractsInfo.values.map((contract) => contract.name).toList(),
    );
  }
}
