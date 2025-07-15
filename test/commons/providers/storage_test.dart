import 'dart:convert';
import 'dart:ui';

import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';

void main() {
  group("#game", () {
    final game = createGame(
      4,
      [defaultBarbu, defaultNoHearts, defaultSalad, defaultDomino],
    );
    test("should return null when getStoredGame if no game", () async {
      await _initializeStorage();
      expect(MyStorage().getStoredGame(), isNull);
    });
    test("should save and get game", () async {
      await _initializeStorage();
      final storage = MyStorage();
      storage.saveGame(game);

      final storedGame = storage.getStoredGame();
      expect(storedGame, isNotNull);
      expect(
        _convertToComparablePlayers(storedGame!.players),
        _convertToComparablePlayers(game.players),
      );
    });
    test("should delete game", () async {
      await _initializeStorage();
      final storage = MyStorage();

      storage.saveGame(game);
      storage.deleteGame();

      expect(storage.getStoredGame(), isNull);
    });
  });
  group("#isDarkTheme", () {
    for (var isDarkTheme in [true, false]) {
      test("should save and get isDarkTheme with $isDarkTheme", () async {
        await _initializeStorage();
        final storage = MyStorage();

        storage.saveIsDarkTheme(isDarkTheme);

        expect(storage.getIsDarkTheme(), isDarkTheme);
      });
    }
    test("should return null when getIsDarkTheme if no data", () async {
      await _initializeStorage();
      expect(MyStorage().getIsDarkTheme(), isNull);
    });
  });
  group("#settings", () {
    final barbuSettings =
        OneLooserContractSettings(contract: ContractsInfo.barbu, points: 100);
    final noLastTricksSettings = OneLooserContractSettings(
      contract: ContractsInfo.noLastTrick,
      points: 100,
    );
    final noHeartsSettings = MultipleLooserContractSettings(
      contract: ContractsInfo.noHearts,
      points: 20,
    );
    final noTricksSettings = MultipleLooserContractSettings(
      contract: ContractsInfo.noTricks,
      points: 20,
    );
    final noQueensSettings = MultipleLooserContractSettings(
      contract: ContractsInfo.noQueens,
      points: 20,
    );
    final saladSettings = SaladContractSettings(
      isActive: false,
      contracts: {
        for (var contract in SaladContractSettings.availableContracts)
          contract.name: true
      },
    );
    final dominoSettings = DominoContractSettings(
      points: {
        4: [1, 2, 3, 4]
      },
    );
    for (var contract in ContractsInfo.values) {
      test(
          "should return default settings when no saved settings for $contract",
          () async {
        await _initializeStorage();
        expect(MyStorage().getSettings(contract), contract.defaultSettings);
      });
      test("should save and get settings for $contract", () async {
        await _initializeStorage();
        final settings = [
          barbuSettings,
          noLastTricksSettings,
          noQueensSettings,
          noHeartsSettings,
          noTricksSettings,
          dominoSettings,
          saladSettings
        ].firstWhere((settings) => settings.name == contract.name);
        final storage = MyStorage();
        storage.saveSettings(contract, settings);

        expect(storage.getSettings(contract), settings);
      });
    }
    for (var activeContracts in [
      ContractsInfo.values,
      [ContractsInfo.barbu, ContractsInfo.noHearts],
      []
    ]) {
      test("should get active contracts with $activeContracts", () async {
        await _initializeStorage(data: {
          for (ContractsInfo contract in ContractsInfo.values)
            contract.name: jsonEncode((contract.defaultSettings
                    .copyWith(isActive: activeContracts.contains(contract)))
                .toJson())
        });

        final storage = MyStorage();
        expect(storage.getActiveContracts(), activeContracts);
      });
    }
  });
  group("#locale", () {
    const locale = Locale("fr");
    test("should return null when getLocale if no locale saved", () async {
      await _initializeStorage();
      expect(MyStorage().getLocale(), isNull);
    });
    test("should save and get locale", () async {
      await _initializeStorage();
      final storage = MyStorage();

      storage.saveLocale(locale);

      expect(storage.getLocale(), locale);
    });
  });
}

List<Map<String, Object>>? _convertToComparablePlayers(List<Player> players) {
  return players
      .map(
        (player) =>
            {'name': player.name, 'color': player.color, 'image': player.image},
      )
      .toList();
}

Future<void> _initializeStorage({Map<String, Object>? data}) async {
  SharedPreferences.setMockInitialValues(data ?? {});
  MyStorage.storage = await SharedPreferences.getInstance();
}
