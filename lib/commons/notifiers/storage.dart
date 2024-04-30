import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import '../models/contract_info.dart';
import '../models/contract_settings_models.dart';
import '../models/game.dart';
import '../utils/globals.dart' as globals;

final storageProvider = Provider((ref) => MyStorage2());

/// A class to handle local storage objects
class MyStorage2 {
  static const _settingsBoxName = "settings";
  static const _gameBoxName = "game";

  static const String _gameKey = "game";
  static const String _isDarkThemeKey = "isDarkTheme";

  /// Returns true if a game is saved in storage, false otherwise
  bool hasStoredGame() {
    final storedGame = getStoredGame();
    return storedGame != null && !storedGame.isFinished;
  }

  /// Gets the game saved in the store
  Game? getStoredGame() {
    var storedGame = Hive.box(_gameBoxName).get(_gameKey);
    if (storedGame != null) {
      globals.nbPlayers = storedGame.players.length;
      return storedGame;
    }
    return null;
  }

  /// Saves the game status
  void saveGame(Game game) {
    Hive.box(_gameBoxName).put(_gameKey, game);
  }

  /// Deletes the data saved for the game in the store
  void deleteGame() {
    globals.nbPlayers = 0;
    Hive.box(_gameBoxName).clear();
  }

  /// Returns true if saved theme is dark, false if it is white. If nothing saved, returns null
  bool? getIsDarkTheme() {
    return Hive.box(_settingsBoxName).get(_isDarkThemeKey);
  }

  /// Saves true if app theme should be dark, false otherwise
  static void saveIsDarkTheme(bool isDarkTheme) {
    Hive.box(_settingsBoxName).put(_isDarkThemeKey, isDarkTheme);
  }

  /// Gets the settings associated to this contract. Returns default settings if no personalized data saved
  AbstractContractSettings getSettings(ContractsInfo contractsInfo) {
    return Hive.box(_settingsBoxName)
        .get(contractsInfo.name, defaultValue: contractsInfo.defaultSettings)
        .copy();
  }

  /// Returns all active contracts
  List<ContractsInfo> getActiveContracts() {
    return List<ContractsInfo>.from(ContractsInfo.values)
      ..removeWhere((contract) => !getSettings(contract).isActive);
  }

  /// Saves contract settings and deletes the current game
  void saveSettings(
      ContractsInfo contractsInfo, AbstractContractSettings settings) {
    deleteGame();
    Hive.box(_settingsBoxName).put(contractsInfo.name, settings);
  }

  /// Listens to contract settings changes
  ValueListenable listenContractsSettings() {
    return Hive.box(_settingsBoxName).listenable(
      keys: ContractsInfo.values.map((contract) => contract.name).toList(),
    );
  }
}
