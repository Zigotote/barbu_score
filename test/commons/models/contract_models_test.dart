import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

main() {
  group("#OneLooserContractModel", () {
    const contract = ContractsInfo.barbu;
    group("#isValid", () {
      for (var nbItems in [0, 1, 2]) {
        test(
            "should be ${nbItems == 1 ? "valid" : "invalid"} with $nbItems item",
            () {
          final model = OneLooserContractModel(contract: contract);
          final itemsByPlayer = {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? nbItems : 0
          };

          expect(model.isValid(itemsByPlayer), nbItems == 1);
        });
      }
      for (var nbItems in [1, 2]) {
        test("should be invalid with multiple players with $nbItems item", () {
          final model = OneLooserContractModel(contract: contract);
          final itemsByPlayer = {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? 1 : nbItems
          };

          expect(model.isValid(itemsByPlayer), false);
        });
      }
    });
    group("#setItemsByPlayer", () {
      test("should set itemsByPlayer when items are valid", () {
        final model = OneLooserContractModel(contract: contract);
        final itemsByPlayer = {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0 ? 1 : 0
        };

        model.setItemsByPlayer(itemsByPlayer);

        expect(model.itemsByPlayer, itemsByPlayer);
      });
      test("should not set itemsByPlayer when items are invalid", () {
        final model = OneLooserContractModel(contract: contract);
        final itemsByPlayer = {
          for (var player in defaultPlayerNames) player: 0
        };

        model.setItemsByPlayer(itemsByPlayer);

        expect(model.itemsByPlayer, isEmpty);
      });
    });
    group("#scores", () {
      test("should be null if no itemsByPlayer", () {
        final model = OneLooserContractModel(contract: contract);

        expect(model.scores(contract.defaultSettings), isNull);
      });
      test("should calculate scores from settings", () {
        final model = OneLooserContractModel(contract: contract);
        final itemsByPlayer = {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0 ? 1 : 0
        };
        model.setItemsByPlayer(itemsByPlayer);

        final expectedScores = {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0
                ? (contract.defaultSettings as OneLooserContractSettings).points
                : 0
        };

        expect(model.scores(contract.defaultSettings), expectedScores);
      });
    });
  });

  group("#MultipleLooserContractModel", () {
    const contract = ContractsInfo.noQueens;
    final nbItemsForContract = defaultPlayerNames.length;

    for (var nbItems in [0, 1, 2]) {
      test(
          "should be ${nbItems == 1 ? "valid" : "invalid"} with $nbItems item by player",
          () {
        final model = MultipleLooserContractModel(
          contract: contract,
          nbItems: nbItemsForContract,
        );
        final itemsByPlayer = {
          for (var player in defaultPlayerNames) player: 1 * nbItems
        };

        expect(model.isValid(itemsByPlayer), nbItems == 1);
      });
    }
    group("#setItemsByPlayer", () {
      test("should set itemsByPlayer when items are valid", () {
        final model = MultipleLooserContractModel(
          contract: contract,
          nbItems: nbItemsForContract,
        );
        final itemsByPlayer = {
          for (var player in defaultPlayerNames) player: 1
        };

        model.setItemsByPlayer(itemsByPlayer);

        expect(model.itemsByPlayer, itemsByPlayer);
      });
      test("should not set itemsByPlayer when items are invalid", () {
        final model = MultipleLooserContractModel(
          contract: contract,
          nbItems: nbItemsForContract,
        );
        final itemsByPlayer = {
          for (var player in defaultPlayerNames) player: 0
        };

        model.setItemsByPlayer(itemsByPlayer);

        expect(model.itemsByPlayer, isEmpty);
      });
    });
    group("#scores", () {
      test("should be null if no itemsByPlayer", () {
        final model = MultipleLooserContractModel(
          contract: contract,
          nbItems: nbItemsForContract,
        );

        expect(model.scores(contract.defaultSettings), isNull);
      });
      test(
          "should calculate scores from settings with multiple players with items",
          () {
        final model = MultipleLooserContractModel(
          contract: contract,
          nbItems: nbItemsForContract,
        );
        final itemsByPlayer = {
          for (var player in defaultPlayerNames) player: 1
        };
        model.setItemsByPlayer(itemsByPlayer);

        final expectedScores = {
          for (var player in defaultPlayerNames)
            player: (contract.defaultSettings as MultipleLooserContractSettings)
                .points
        };

        expect(model.scores(contract.defaultSettings), expectedScores);
      });
      for (var invertScore in [true, false]) {
        test(
            "should calculate scores from settings with one player with items and invert scores is $invertScore",
            () {
          final model = MultipleLooserContractModel(
            contract: contract,
            nbItems: nbItemsForContract,
          );
          final itemsByPlayer = {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? nbItemsForContract : 0
          };
          model.setItemsByPlayer(itemsByPlayer);

          final settings = MultipleLooserContractSettings(
            contract: contract,
            points: 10,
            invertScore: invertScore,
          );
          final expectedScores = {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0
                  ? nbItemsForContract *
                      settings.points *
                      (invertScore ? -1 : 1)
                  : 0
          };

          expect(model.scores(settings), expectedScores);
        });
      }
    });
  });

  group("#TrumpsContractModel", () {
    const contract = ContractsInfo.trumps;

    for (var replaceSubContract in [true, false]) {
      test("should ${replaceSubContract ? "replace" : "add"} sub contract", () {
        final model = TrumpsContractModel();
        final subContract =
            OneLooserContractModel(contract: ContractsInfo.noQueens);
        subContract.setItemsByPlayer({
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0 ? 1 : 0
        });
        Map<String, int> expectedItemsByPlayer = subContract.itemsByPlayer;

        model.addSubContract(subContract);
        if (replaceSubContract) {
          expectedItemsByPlayer = {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 1 ? 1 : 0
          };
          subContract.setItemsByPlayer(expectedItemsByPlayer);
          model.addSubContract(subContract);
        }

        expect(model.subContracts.length, 1);
        expect(model.subContracts.first.itemsByPlayer, expectedItemsByPlayer);
      });
    }

    group("#scores", () {
      final barbuSettings =
          ContractsInfo.barbu.defaultSettings as OneLooserContractSettings;
      final noQueensSettings = ContractsInfo.noQueens.defaultSettings
          as MultipleLooserContractSettings;
      final noTricksSettings = ContractsInfo.noTricks.defaultSettings
          as MultipleLooserContractSettings;
      final noHeartsSettings = ContractsInfo.noHearts.defaultSettings
          as MultipleLooserContractSettings;
      final noLastTrickSettings = ContractsInfo.noLastTrick.defaultSettings
          as OneLooserContractSettings;
      final subContractSettings = [
        barbuSettings,
        noQueensSettings,
        noTricksSettings,
        noHeartsSettings,
        noLastTrickSettings,
      ];
      test("should be null if no sub contract", () {
        final model = TrumpsContractModel();

        expect(model.scores(contract.defaultSettings, subContractSettings),
            isNull);
      });
      test("should be null if no sub contract settings", () {
        final model = TrumpsContractModel();
        model.addSubContract(
          OneLooserContractModel(contract: ContractsInfo.barbu),
        );

        expect(model.scores(contract.defaultSettings), isNull);
      });
      test("should be null if sub contract has no associated settings", () {
        const subContract = ContractsInfo.barbu;
        final model = TrumpsContractModel();
        model.addSubContract(OneLooserContractModel(contract: subContract));

        expect(
            model.scores(
              contract.defaultSettings,
              subContractSettings
                  .where((settings) => settings.name != subContract.name)
                  .toList(),
            ),
            isNull);
      });
      test("should sum sub contract scores", () {
        final barbu = OneLooserContractModel(contract: ContractsInfo.barbu);
        barbu.setItemsByPlayer({
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0 ? 1 : 0
        });
        final noQueens = MultipleLooserContractModel(
          contract: ContractsInfo.noQueens,
          nbItems: 4,
        );
        noQueens.setItemsByPlayer(
          {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index < 4 ? 1 : 0
          },
        );
        final noTricks = MultipleLooserContractModel(
          contract: ContractsInfo.noTricks,
          nbItems: 8,
        );
        noTricks.setItemsByPlayer(
          {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index < 4 ? 2 : 0
          },
        );
        final noHearts = MultipleLooserContractModel(
          contract: ContractsInfo.noHearts,
          nbItems: 8,
        );
        noHearts.setItemsByPlayer(
          {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index < 4 ? 2 : 0
          },
        );
        final noLastTrick = OneLooserContractModel(
          contract: ContractsInfo.noLastTrick,
        );
        noLastTrick.setItemsByPlayer(
          {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? 1 : 0
          },
        );
        final model = TrumpsContractModel(
          subContracts: [barbu, noQueens, noHearts, noLastTrick, noTricks],
        );

        expect(model.scores(contract.defaultSettings, subContractSettings), {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0
                ? barbuSettings.points +
                    noLastTrickSettings.points +
                    noQueensSettings.points +
                    (noHeartsSettings.points * 2) +
                    (noTricksSettings.points * 2)
                : index < 4
                    ? noQueensSettings.points +
                        (noHeartsSettings.points * 2) +
                        (noTricksSettings.points * 2)
                    : 0
        });
      });
      test("should sum sub contract scores when one players wons all", () {
        final barbu = OneLooserContractModel(contract: ContractsInfo.barbu);
        barbu.setItemsByPlayer({
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0 ? 1 : 0
        });
        final noQueens = MultipleLooserContractModel(
          contract: ContractsInfo.noQueens,
          nbItems: 4,
        );
        noQueens.setItemsByPlayer(
          {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? noQueens.nbItems : 0
          },
        );
        final noTricks = MultipleLooserContractModel(
          contract: ContractsInfo.noTricks,
          nbItems: 8,
        );
        noTricks.setItemsByPlayer(
          {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? noTricks.nbItems : 0
          },
        );
        final noHearts = MultipleLooserContractModel(
          contract: ContractsInfo.noHearts,
          nbItems: 8,
        );
        noHearts.setItemsByPlayer(
          {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? noHearts.nbItems : 0
          },
        );
        final noLastTrick = OneLooserContractModel(
          contract: ContractsInfo.noLastTrick,
        );
        noLastTrick.setItemsByPlayer(
          {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? 1 : 0
          },
        );
        final model = TrumpsContractModel(
          subContracts: [barbu, noQueens, noHearts, noLastTrick, noTricks],
        );

        expect(model.scores(contract.defaultSettings, subContractSettings), {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0
                ? barbuSettings.points +
                    noLastTrickSettings.points +
                    -(noQueensSettings.points * noQueens.nbItems) +
                    -(noHeartsSettings.points * noHearts.nbItems) +
                    -(noTricksSettings.points * noTricks.nbItems)
                : 0
        });
      });
    });
  });

  group("#DominoContractModel", () {
    group("#setRankOfPlayer", () {
      test("should return false if rankOfPlayer is empty", () {
        final model = DominoContractModel();

        expect(model.setRankOfPlayer({}), isFalse);
      });
      test("should return true if rankOfPlayer is not empty", () {
        final model = DominoContractModel();

        expect(
          model.setRankOfPlayer({
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index
          }),
          isTrue,
        );
      });
    });
    group("#scores", () {
      test("should be null if no rank", () {
        final model = DominoContractModel();

        expect(model.scores(ContractsInfo.domino.defaultSettings), isNull);
      });
      test("should return scores of player, depending on their rank", () {
        final settings =
            ContractsInfo.domino.defaultSettings as DominoContractSettings;
        final model = DominoContractModel();
        model.setRankOfPlayer({
          for (var (index, player) in defaultPlayerNames.indexed) player: index
        });

        expect(model.scores(settings), {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: settings.points[defaultPlayerNames.length]?[index]
        });
      });
    });
  });
}
