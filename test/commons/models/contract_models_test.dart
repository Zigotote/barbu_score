import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/utils.dart';

void main() {
  group("#ContractWithPointsModel", () {
    const contract = ContractsInfo.noQueens;
    final nbItemsForContract = defaultPlayerNames.length;

    for (var nbItems in [0, 1, 2]) {
      test(
        "should be ${nbItems == 1 ? "valid" : "invalid"} with $nbItems item by player",
        () {
          final model = ContractWithPointsModel(
            contract: contract,
            nbItems: nbItemsForContract,
          );
          final itemsByPlayer = {
            for (var player in defaultPlayerNames) player: 1 * nbItems,
          };

          expect(model.isValid(itemsByPlayer), nbItems == 1);
        },
      );
    }
    test("should be valid with some discarded items", () {
      final model = ContractWithPointsModel(
        contract: contract,
        nbItems: nbItemsForContract,
      );
      final itemsByPlayer = {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index % 2 == 1 ? 1 : 0,
      };

      expect(
        model.isValid(itemsByPlayer, (nbItemsForContract / 2).toInt()),
        isTrue,
      );
    });
    group("#scores", () {
      test("should be null if no itemsByPlayer", () {
        final model = ContractWithPointsModel(
          contract: contract,
          nbItems: nbItemsForContract,
        );

        expect(model.scores(contract.defaultSettings), isNull);
      });
      test(
        "should calculate scores from settings with multiple players with items",
        () {
          final itemsByPlayer = {
            for (var player in defaultPlayerNames) player: 1,
          };
          final model = ContractWithPointsModel(
            contract: contract,
            itemsByPlayer: itemsByPlayer,
            nbItems: nbItemsForContract,
          );

          final expectedScores = {
            for (var player in defaultPlayerNames)
              player: (contract.defaultSettings as ContractWithPointsSettings)
                  .points,
          };

          expect(model.scores(contract.defaultSettings), expectedScores);
        },
      );
      for (var invertScore in [true, false]) {
        test(
          "should calculate scores from settings with one player with items and invert scores is $invertScore",
          () {
            final itemsByPlayer = {
              for (var (index, player) in defaultPlayerNames.indexed)
                player: index == 0 ? nbItemsForContract : 0,
            };
            final model = ContractWithPointsModel(
              contract: contract,
              itemsByPlayer: itemsByPlayer,
              nbItems: nbItemsForContract,
            );

            final settings = ContractWithPointsSettings(
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
                    : 0,
            };

            expect(model.scores(settings), expectedScores);
          },
        );
      }
    });
  });

  group("#SaladContractModel", () {
    const contract = ContractsInfo.salad;

    for (var replaceSubContract in [true, false]) {
      test("should ${replaceSubContract ? "replace" : "add"} sub contract", () {
        final model = SaladContractModel();
        final subContract = ContractWithPointsModel(
          contract: ContractsInfo.noQueens,
          nbItems: 4,
          itemsByPlayer: {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 0 ? 1 : 0,
          },
        );
        Map<String, int> expectedItemsByPlayer = subContract.itemsByPlayer;

        model.addSubContract(subContract);
        if (replaceSubContract) {
          expectedItemsByPlayer = {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index == 1 ? 1 : 0,
          };
          model.addSubContract(
            subContract.copyWith(itemsByPlayer: expectedItemsByPlayer),
          );
        }

        expect(model.subContracts.length, 1);
        expect(model.subContracts.first.itemsByPlayer, expectedItemsByPlayer);
      });
    }

    group("#scores", () {
      final barbuSettings =
          ContractsInfo.barbu.defaultSettings as ContractWithPointsSettings;
      final noQueensSettings =
          ContractsInfo.noQueens.defaultSettings as ContractWithPointsSettings;
      final noTricksSettings =
          ContractsInfo.noTricks.defaultSettings as ContractWithPointsSettings;
      final noHeartsSettings =
          ContractsInfo.noHearts.defaultSettings as ContractWithPointsSettings;
      final noLastTrickSettings =
          ContractsInfo.noLastTrick.defaultSettings
              as ContractWithPointsSettings;
      final subContractSettings = [
        barbuSettings,
        noQueensSettings,
        noTricksSettings,
        noHeartsSettings,
        noLastTrickSettings,
      ];
      test("should be null if no sub contract", () {
        final model = SaladContractModel();

        expect(
          model.scores(contract.defaultSettings, subContractSettings),
          isNull,
        );
      });
      test("should be null if no sub contract settings", () {
        final model = SaladContractModel(
          subContracts: [
            ContractWithPointsModel(contract: ContractsInfo.barbu),
          ],
        );

        expect(model.scores(contract.defaultSettings), isNull);
      });
      test("should be null if sub contract has no associated settings", () {
        const subContract = ContractsInfo.barbu;
        final model = SaladContractModel(
          subContracts: [ContractWithPointsModel(contract: subContract)],
        );

        expect(
          model.scores(
            contract.defaultSettings,
            subContractSettings
                .where((settings) => settings.name != subContract.name)
                .toList(),
          ),
          isNull,
        );
      });
      test("should sum sub contract scores", () {
        expect(
          defaultSalad.scores(contract.defaultSettings, subContractSettings),
          {
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
                  : 0,
          },
        );
      });
      test("should sum sub contract scores with some removed contracts", () {
        final settings = SaladContractSettings(
          isActive: true,
          contracts: {
            ContractsInfo.barbu.name: false,
            ContractsInfo.noLastTrick.name: true,
            ContractsInfo.noHearts.name: false,
            ContractsInfo.noTricks.name: false,
            ContractsInfo.noQueens.name: true,
          },
        );

        expect(defaultSalad.scores(settings, subContractSettings), {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0
                ? noLastTrickSettings.points + noQueensSettings.points
                : index < 4
                ? noQueensSettings.points
                : 0,
        });
      });
      test("should sum sub contract scores with some missing contracts", () {
        final model = SaladContractModel(
          subContracts: [defaultBarbu, defaultNoQueens, defaultNoHearts],
        );

        expect(model.scores(contract.defaultSettings, subContractSettings), {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: index == 0
                ? barbuSettings.points +
                      noQueensSettings.points +
                      (noHeartsSettings.points * 2)
                : index < 4
                ? noQueensSettings.points + (noHeartsSettings.points * 2)
                : 0,
        });
      });
      for (var invertScore in [true, false]) {
        test(
          "should sum sub contract scores when one players wons all and invert scores is $invertScore",
          () {
            final barbu = ContractWithPointsModel(
              contract: ContractsInfo.barbu,
              itemsByPlayer: {
                for (var (index, player) in defaultPlayerNames.indexed)
                  player: index == 0 ? 1 : 0,
              },
            );
            const nbNoQueens = 4;
            final noQueens = ContractWithPointsModel(
              contract: ContractsInfo.noQueens,
              itemsByPlayer: {
                for (var (index, player) in defaultPlayerNames.indexed)
                  player: index == 0 ? nbNoQueens : 0,
              },
              nbItems: nbNoQueens,
            );
            const nbNoTricks = 8;
            final noTricks = ContractWithPointsModel(
              contract: ContractsInfo.noTricks,
              itemsByPlayer: {
                for (var (index, player) in defaultPlayerNames.indexed)
                  player: index == 0 ? nbNoTricks : 0,
              },
              nbItems: nbNoTricks,
            );
            const nbNoHearts = 8;
            final noHearts = ContractWithPointsModel(
              contract: ContractsInfo.noHearts,
              itemsByPlayer: {
                for (var (index, player) in defaultPlayerNames.indexed)
                  player: index == 0 ? nbNoHearts : 0,
              },
              nbItems: nbNoHearts,
            );
            final noLastTrick = ContractWithPointsModel(
              contract: ContractsInfo.noLastTrick,
              itemsByPlayer: {
                for (var (index, player) in defaultPlayerNames.indexed)
                  player: index == 0 ? 1 : 0,
              },
            );
            final model = SaladContractModel(
              subContracts: [barbu, noQueens, noHearts, noLastTrick, noTricks],
            );
            final settings = (contract.defaultSettings as SaladContractSettings)
                .copyWith(invertScore: invertScore);

            final expectedScore = invertScore
                ? ((barbuSettings.points +
                          noLastTrickSettings.points +
                          (noQueensSettings.points * noQueens.nbItems) +
                          (noHeartsSettings.points * noHearts.nbItems) +
                          (noTricksSettings.points * noTricks.nbItems)) *
                      -1)
                : (barbuSettings.points +
                      noLastTrickSettings.points +
                      -(noQueensSettings.points * noQueens.nbItems) +
                      -(noHeartsSettings.points * noHearts.nbItems) +
                      -(noTricksSettings.points * noTricks.nbItems));

            expect(model.scores(settings, subContractSettings), {
              for (var (index, player) in defaultPlayerNames.indexed)
                player: index == 0 ? expectedScore : 0,
            });
          },
        );
      }
    });
  });

  group("#DominoContractModel", () {
    group("#scores", () {
      test("should be null if no rank", () {
        final model = DominoContractModel();

        expect(model.scores(ContractsInfo.domino.defaultSettings), isNull);
      });
      test("should return scores of player, depending on their rank", () {
        final settings =
            ContractsInfo.domino.defaultSettings as DominoContractSettings;
        final model = DominoContractModel(
          rankOfPlayer: {
            for (var (index, player) in defaultPlayerNames.indexed)
              player: index,
          },
        );

        expect(model.scores(settings), {
          for (var (index, player) in defaultPlayerNames.indexed)
            player: settings.points[defaultPlayerNames.length]?[index],
        });
      });
    });
  });
}
