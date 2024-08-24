import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils.dart';

main() {
  group("#game", () {
    final barbu = OneLooserContractModel(
      contract: ContractsInfo.barbu,
      itemsByPlayer: {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index == 0 ? 1 : 0
      },
    );
    final noHearts = MultipleLooserContractModel(
      contract: ContractsInfo.noQueens,
      nbItems: 4,
      itemsByPlayer: {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index == 0 ? 4 : 0
      },
    );
    final game = Game(
      players: List.generate(
        4,
        (index) => Player(
          name: defaultPlayerNames[index],
          color: PlayerColors.values[index],
          image: playerImages[index],
          contracts: [
            barbu,
            noHearts,
            TrumpsContractModel(subContracts: [barbu, noHearts]),
            DominoContractModel(
              rankOfPlayer: {
                for (var (index, player) in defaultPlayerNames.indexed)
                  player: index
              },
            )
          ],
        ),
      ),
    );
    test("should return null when getStoredGame if no game", () async {
      await _initializeStorage();
      expect(MyStorage().getStoredGame(), isNull);
    });
    test("should save and get game", () async {
      await _initializeStorage();
      final storage = MyStorage();
      storage.saveGame(game);

      expect(storage.getStoredGame(), game);
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
    final trumpsSettings = TrumpsContractSettings(
      isActive: false,
      contracts: {
        for (var contract in TrumpsContractSettings.availableContracts)
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
          trumpsSettings
        ].firstWhere((settings) => settings.name == contract.name);
        final storage = MyStorage();
        storage.saveSettings(contract, settings);

        expect(storage.getSettings(contract), settings);
      });
    }
  });
}

Future<void> _initializeStorage() async {
  SharedPreferences.setMockInitialValues({});
  MyStorage.storage = await SharedPreferences.getInstance();
}