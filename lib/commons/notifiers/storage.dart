import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contract_info.dart';
import '../models/contract_settings_models.dart';
import '../models/game.dart';

final storageProvider = Provider((ref) => MyStorage());

/// A class to handle local storage objects
class MyStorage {
  static const _settingsBoxName = "settings";
  static const String _gameKey = "game";
  static const String _isDarkThemeKey = "isDarkTheme";

  /// The object to manipulate local storage
  @visibleForTesting
  static SharedPreferences? storage;

  /// The function to call to init storage
  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<ContractsInfo>(ContractsInfoAdapter());
    Hive.registerAdapter<OneLooserContractSettings>(
        OneLooserContractSettingsAdapter());
    Hive.registerAdapter<MultipleLooserContractSettings>(
        MultipleLooserContractSettingsAdapter());
    Hive.registerAdapter<TrumpsContractSettings>(
        TrumpsContractSettingsAdapter());
    Hive.registerAdapter<DominoContractSettings>(
        DominoContractSettingsAdapter());
    await Hive.openBox(_settingsBoxName);

    storage = await SharedPreferences.getInstance();
    // Migrates Hive data to SharedPreferences
    final isDarkTheme = Hive.box(_settingsBoxName).get(_isDarkThemeKey);
    if (isDarkTheme != null) {
      storage?.setBool(_isDarkThemeKey, isDarkTheme);
    }
    for (var contract in ContractsInfo.values) {
      final AbstractContractSettings? contractSettings =
          Hive.box(_settingsBoxName).get(contract.name);
      if (contractSettings != null) {
        final json = contractSettings.toJson();
        if (json["name"]?.isEmpty) {
          json["name"] = contract.name;
        }
        storage?.setString(
          contract.name,
          jsonEncode(json),
        );
      }
    }
    await Hive.box(_settingsBoxName).clear();
  }

  /// Returns true if a game is saved in storage, false otherwise
  bool hasStoredGame() {
    final storedGame = getStoredGame();
    return storedGame != null && !storedGame.isFinished;
  }

  /// Gets the game saved in the store
  Game? getStoredGame() {
    final storedGame = storage?.getString(_gameKey);
    if (storedGame != null) {
      return Game.fromJson(jsonDecode(storedGame));
    }
    return null;
  }

  /// Saves the game status
  void saveGame(Game game) {
    storage?.setString(_gameKey, jsonEncode(game.toJson()));
  }

  /// Deletes the data saved for the game in the store
  void deleteGame() {
    storage?.remove(_gameKey);
  }

  /// Returns true if saved theme is dark, false if it is white. If nothing saved, returns null
  bool? getIsDarkTheme() {
    return storage?.getBool(_isDarkThemeKey);
  }

  /// Saves true if app theme should be dark, false otherwise
  void saveIsDarkTheme(bool isDarkTheme) {
    storage?.setBool(_isDarkThemeKey, isDarkTheme);
  }

  /// Gets the settings associated to this contract. Returns default settings if no personalized data saved
  AbstractContractSettings getSettings(ContractsInfo contractsInfo) {
    final storedSettings = storage?.getString(contractsInfo.name);
    if (storedSettings != null) {
      return AbstractContractSettings.fromJson(jsonDecode(storedSettings));
    }
    return contractsInfo.defaultSettings;
  }

  /// Saves contract settings and deletes the current game
  void saveSettings(
      ContractsInfo contractsInfo, AbstractContractSettings settings) {
    deleteGame();
    storage?.setString(contractsInfo.name, jsonEncode(settings.toJson()));
  }

  /// Returns all active contracts
  List<ContractsInfo> getActiveContracts() {
    return List<ContractsInfo>.from(ContractsInfo.values)
      ..removeWhere((contract) => !getSettings(contract).isActive);
  }
}
