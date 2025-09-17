import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';

import '../models/contract_info.dart';
import '../models/contract_settings_models.dart';
import '../models/game.dart';
import '../utils/constants.dart';

final storageProvider = Provider((ref) => MyStorage());

/// A class to handle local storage objects
class MyStorage {
  static const String _gameKey = "game";
  static const String _isDarkThemeKey = "isDarkTheme";
  static const String _localeKey = "locale";

  /// The object to manipulate local storage
  @visibleForTesting
  static SharedPreferencesWithCache? storage;

  /// The function to call to init storage
  static Future<void> init() async {
    // TODO temporary to migrate shared preferences data. To remove in a few versions
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await migrateLegacySharedPreferencesToSharedPreferencesAsyncIfNecessary(
      legacySharedPreferencesInstance: prefs,
      sharedPreferencesAsyncOptions: SharedPreferencesOptions(),
      migrationCompletedKey: 'migrationCompleted',
    );

    storage = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(),
    );

    // TODO Temporary to migrate trumps settings to salad settings
    final saladSettings = storage?.getString(ContractsInfo.salad.name);
    if (saladSettings != null) {
      storage?.setString(
        ContractsInfo.salad.name,
        jsonEncode(
          AbstractContractSettings.fromJson(jsonDecode(saladSettings)),
        ),
      );
    }
    // TODO Temporary to migrate domino settings for 6+ players
    final savedDominoSettings = storage?.getString(ContractsInfo.domino.name);
    if (savedDominoSettings != null) {
      final dominoSettings =
          AbstractContractSettings.fromJson(jsonDecode(savedDominoSettings))
              as DominoContractSettings;
      if (!dominoSettings.points.containsKey(7)) {
        final newPoints = Map<int, List<int>>.from(dominoSettings.points);
        final defaultPoints =
            (ContractsInfo.domino.defaultSettings as DominoContractSettings)
                .points;
        for (var nbPlayer = 7; nbPlayer <= kNbPlayersMax; nbPlayer++) {
          newPoints[nbPlayer] = defaultPoints[nbPlayer]!;
        }
        storage?.setString(
          ContractsInfo.domino.name,
          jsonEncode(dominoSettings.copyWith(points: newPoints).toJson()),
        );
      }
    }
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
    String? storedSettings = storage?.getString(contractsInfo.name);
    if (storedSettings != null) {
      return AbstractContractSettings.fromJson(jsonDecode(storedSettings));
    }
    return contractsInfo.defaultSettings;
  }

  /// Saves contract settings and deletes the current game
  void saveSettings(
      ContractsInfo contractsInfo, AbstractContractSettings settings) {
    storage?.setString(contractsInfo.name, jsonEncode(settings.toJson()));
  }

  /// Returns all active contracts
  List<ContractsInfo> getActiveContracts() {
    return List<ContractsInfo>.from(ContractsInfo.values)
      ..removeWhere((contract) => !getSettings(contract).isActive);
  }

  /// Saves the locale to use in the app
  void saveLocale(Locale locale) {
    storage?.setString(_localeKey, locale.languageCode);
  }

  /// Returns the locale saved in the storage, or null if nothing is saved
  Locale? getLocale() {
    final savedLocale = storage?.getString(_localeKey);
    if (savedLocale != null) {
      return Locale(savedLocale);
    }
    return null;
  }
}
