import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/providers/contracts_manager.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:barbu_score/theme/my_theme_colors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

void main() {
  // Custom settings
  final mockStorage = MockMyStorage();
  final barbuSettings = ContractWithPointsSettings(
    contract: ContractsInfo.barbu,
    points: 30,
  );
  final noQueensSettings = ContractWithPointsSettings(
    contract: ContractsInfo.noQueens,
    points: 15,
    invertScore: true,
  );
  final noTricksSettings = ContractWithPointsSettings(
    contract: ContractsInfo.noTricks,
    points: 10,
    invertScore: true,
  );
  final noHeartsSettings = ContractWithPointsSettings(
    contract: ContractsInfo.noHearts,
    points: 5,
    invertScore: true,
  );
  final noLastTrickSettings = ContractWithPointsSettings(
    contract: ContractsInfo.noLastTrick,
    points: 50,
  );
  final dominoSettings = DominoContractSettings(points: {
    4: [-10, -5, 5, 10]
  });

  // Items by players
  final playerNames = defaultPlayerNames.take(4).toList();
  final barbu = ContractWithPointsModel(
    contract: ContractsInfo.barbu,
    itemsByPlayer: {
      for (var (index, player) in playerNames.indexed)
        player: index == 0 ? 1 : 0
    },
  );
  final noQueens = ContractWithPointsModel(
    contract: ContractsInfo.noQueens,
    itemsByPlayer: {for (var player in playerNames) player: 1},
    nbItems: 4,
  );
  final noTricks = ContractWithPointsModel(
    contract: ContractsInfo.noTricks,
    itemsByPlayer: {for (var player in playerNames) player: 2},
    nbItems: 8,
  );
  final noHearts = ContractWithPointsModel(
    contract: ContractsInfo.noHearts,
    itemsByPlayer: {for (var player in playerNames) player: 2},
    nbItems: 8,
  );
  final noLastTrick = ContractWithPointsModel(
    contract: ContractsInfo.noLastTrick,
    itemsByPlayer: {
      for (var (index, player) in playerNames.indexed)
        player: index == 0 ? 1 : 0
    },
  );
  final domino = DominoContractModel(rankOfPlayer: {
    for (var (index, player) in playerNames.indexed) player: index
  });
  final salad = SaladContractModel(
    subContracts: [barbu, noQueens, noHearts, noLastTrick, noTricks],
  );

  // Expected scores
  final barbuScores = {
    for (var (index, player) in playerNames.indexed)
      player: index == 0 ? barbuSettings.points : 0
  };
  final noHeartsScores = {
    for (var player in playerNames) player: noHeartsSettings.points * 2
  };
  final noQueensScores = {
    for (var player in playerNames) player: noQueensSettings.points
  };
  final noTricksScores = {
    for (var player in playerNames) player: noTricksSettings.points * 2
  };
  final noLastTricksScores = {
    for (var (index, player) in playerNames.indexed)
      player: index == 0 ? noLastTrickSettings.points : 0
  };
  final dominoScores = {
    for (var (index, player) in playerNames.indexed)
      player: dominoSettings.points[playerNames.length]![index]
  };
  final saladScores = {
    for (var (index, player) in playerNames.indexed)
      player: index == 0
          ? barbuSettings.points +
              noHeartsSettings.points * 2 +
              noQueensSettings.points +
              noTricksSettings.points * 2 +
              noLastTrickSettings.points
          : noHeartsSettings.points * 2 +
              noQueensSettings.points +
              noTricksSettings.points * 2
  };

  setUp(() {
    for (var contractSettings in [
      barbuSettings,
      noQueensSettings,
      noTricksSettings,
      noHeartsSettings,
      noLastTrickSettings,
      dominoSettings
    ]) {
      when(mockStorage
              .getSettings(ContractsInfo.fromName(contractSettings.name)))
          .thenReturn(contractSettings);
    }
    when(mockStorage.getSettings(ContractsInfo.salad))
        .thenReturn(ContractsInfo.salad.defaultSettings);
  });

  group("#scoresByContract", () {
    for (var contractsTest in [
      <ContractsInfo>[],
      [ContractsInfo.barbu],
      [ContractsInfo.barbu, ContractsInfo.noQueens, ContractsInfo.domino],
      [
        ContractsInfo.barbu,
        ContractsInfo.noHearts,
        ContractsInfo.noQueens,
        ContractsInfo.noTricks,
        ContractsInfo.noLastTrick,
        ContractsInfo.domino,
        ContractsInfo.salad,
      ]
    ]) {
      final player = Player(
        name: playerNames[0],
        color: MyThemeColors.values[0],
        image: playerImages[0],
        contracts: [
          barbu,
          noQueens,
          noHearts,
          noLastTrick,
          noTricks,
          domino,
          salad
        ]
            .where((contractScores) => contractsTest
                .map((ContractsInfo? contract) => contract?.name)
                .contains(contractScores.name))
            .toList(),
      );
      for (bool hasInactiveContracts in [true, false]) {
        test(
            "should calculate scores by contract for a player with $contractsTest ${hasInactiveContracts ? "with some inactive contracts" : ""}",
            () {
          for (var contractSettings in [
            noTricksSettings,
            noQueensSettings,
            dominoSettings
          ]) {
            when(mockStorage
                    .getSettings(ContractsInfo.fromName(contractSettings.name)))
                .thenReturn(
              contractSettings.copyWith(isActive: !hasInactiveContracts),
            );
          }
          final contractsManager =
              ContractsManager(mockStorage, playerNames.length);

          expect(contractsManager.scoresByContract(player), {
            ContractsInfo.barbu: contractsTest.contains(ContractsInfo.barbu)
                ? barbuScores
                : null,
            ContractsInfo.noHearts:
                contractsTest.contains(ContractsInfo.noHearts)
                    ? noHeartsScores
                    : null,
            if (!hasInactiveContracts)
              ContractsInfo.noQueens:
                  contractsTest.contains(ContractsInfo.noQueens)
                      ? noQueensScores
                      : null,
            if (!hasInactiveContracts)
              ContractsInfo.noTricks:
                  contractsTest.contains(ContractsInfo.noTricks)
                      ? noTricksScores
                      : null,
            ContractsInfo.noLastTrick:
                contractsTest.contains(ContractsInfo.noLastTrick)
                    ? noLastTricksScores
                    : null,
            if (!hasInactiveContracts)
              ContractsInfo.domino: contractsTest.contains(ContractsInfo.domino)
                  ? dominoScores
                  : null,
            ContractsInfo.salad: contractsTest.contains(ContractsInfo.salad)
                ? saladScores
                : null,
          });
        });
      }
    }
  });

  group("#sumScoresByContract", () {
    test("should sum scores when all players have all contracts", () {
      final players = playerNames
          .map(
            (name) => Player(
              name: name,
              color: MyThemeColors.values[0],
              image: playerImages[0],
              contracts: [
                barbu,
                noQueens,
                noHearts,
                noLastTrick,
                noTricks,
                domino,
                salad
              ],
            ),
          )
          .toList();

      final contractsManager =
          ContractsManager(mockStorage, playerNames.length);

      expect(contractsManager.sumScoresByContract(players), {
        ContractsInfo.barbu: barbuScores.map(
          (player, score) => MapEntry(player, score * players.length),
        ),
        ContractsInfo.noHearts: noHeartsScores.map(
          (player, score) => MapEntry(player, score * players.length),
        ),
        ContractsInfo.noQueens: noQueensScores.map(
          (player, score) => MapEntry(player, score * players.length),
        ),
        ContractsInfo.noTricks: noTricksScores.map(
          (player, score) => MapEntry(player, score * players.length),
        ),
        ContractsInfo.noLastTrick: noLastTricksScores.map(
          (player, score) => MapEntry(player, score * players.length),
        ),
        ContractsInfo.domino: dominoScores.map(
          (player, score) => MapEntry(player, score * players.length),
        ),
        ContractsInfo.salad: saladScores.map(
          (player, score) => MapEntry(player, score * players.length),
        ),
      });
    });
    test("should sum scores when players have some contracts", () {
      final players = [
        Player(
          name: playerNames[0],
          color: MyThemeColors.values[0],
          image: playerImages[0],
          contracts: [barbu, noQueens, noHearts],
        ),
        Player(
          name: playerNames[1],
          color: MyThemeColors.values[1],
          image: playerImages[1],
          contracts: [barbu, noHearts, noLastTrick],
        ),
        Player(
          name: playerNames[2],
          color: MyThemeColors.values[2],
          image: playerImages[2],
          contracts: [barbu, noHearts, noTricks],
        ),
        Player(
          name: playerNames[3],
          color: MyThemeColors.values[3],
          image: playerImages[3],
          contracts: [barbu, noTricks, domino],
        ),
      ];
      const nbBarbus = 4;
      const nbNoHearts = 3;
      const nbNoTricks = 2;

      final contractsManager =
          ContractsManager(mockStorage, playerNames.length);

      expect(contractsManager.sumScoresByContract(players), {
        ContractsInfo.barbu: barbuScores.map(
          (player, score) => MapEntry(player, score * nbBarbus),
        ),
        ContractsInfo.noHearts: noHeartsScores.map(
          (player, score) => MapEntry(player, score * nbNoHearts),
        ),
        ContractsInfo.noQueens: noQueensScores,
        ContractsInfo.noTricks: noTricksScores.map(
          (player, score) => MapEntry(player, score * nbNoTricks),
        ),
        ContractsInfo.noLastTrick: noLastTricksScores,
        ContractsInfo.domino: dominoScores,
        ContractsInfo.salad: null,
      });
    });
  });
}
