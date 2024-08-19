import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/notifiers/contracts_manager.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils.dart';
import '../../utils.mocks.dart';

main() {
  // Custom settings
  final mockStorage = MockMyStorage();
  final barbuSettings = OneLooserContractSettings(
    contract: ContractsInfo.barbu,
    points: 30,
  );
  final noQueensSettings = MultipleLooserContractSettings(
    contract: ContractsInfo.noQueens,
    points: 15,
  );
  final noTricksSettings = MultipleLooserContractSettings(
    contract: ContractsInfo.noTricks,
    points: 10,
  );
  final noHeartsSettings = MultipleLooserContractSettings(
    contract: ContractsInfo.noHearts,
    points: 5,
  );
  final noLastTrickSettings = OneLooserContractSettings(
    contract: ContractsInfo.noLastTrick,
    points: 50,
  );
  final dominoSettings = DominoContractSettings(points: {
    4: [-10, -5, 5, 10]
  });
  for (var contractSettings in [
    barbuSettings,
    noQueensSettings,
    noTricksSettings,
    noHeartsSettings,
    noLastTrickSettings,
    dominoSettings
  ]) {
    when(mockStorage.getSettings(ContractsInfo.fromName(contractSettings.name)))
        .thenReturn(contractSettings);
  }
  when(mockStorage.getSettings(ContractsInfo.trumps))
      .thenReturn(ContractsInfo.trumps.defaultSettings);

  // Items by players
  final playerNames = defaultPlayerNames.take(4).toList();
  final barbu = OneLooserContractModel(contract: ContractsInfo.barbu);
  barbu.setItemsByPlayer({
    for (var (index, player) in playerNames.indexed) player: index == 0 ? 1 : 0
  });
  final noQueens = MultipleLooserContractModel(
    contract: ContractsInfo.noQueens,
    nbItems: 4,
  );
  noQueens.setItemsByPlayer({for (var player in playerNames) player: 1});
  final noTricks = MultipleLooserContractModel(
    contract: ContractsInfo.noTricks,
    nbItems: 8,
  );
  noTricks.setItemsByPlayer({for (var player in playerNames) player: 2});
  final noHearts = MultipleLooserContractModel(
    contract: ContractsInfo.noHearts,
    nbItems: 8,
  );
  noHearts.setItemsByPlayer({for (var player in playerNames) player: 2});
  final noLastTrick = OneLooserContractModel(
    contract: ContractsInfo.noLastTrick,
  );
  noLastTrick.setItemsByPlayer(
    {
      for (var (index, player) in playerNames.indexed)
        player: index == 0 ? 1 : 0
    },
  );
  final domino = DominoContractModel();
  domino.setRankOfPlayer(
    {for (var (index, player) in playerNames.indexed) player: index},
  );
  final trumps = TrumpsContractModel(
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
  final trumpsScores = {
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
        ContractsInfo.trumps,
      ]
    ]) {
      test(
          "should calculate scores by contract for a player with $contractsTest",
          () {
        final player = Player(
          name: playerNames[0],
          color: PlayerColors.values[0],
          image: playerImages[0],
          contracts: [
            barbu,
            noQueens,
            noHearts,
            noLastTrick,
            noTricks,
            domino,
            trumps
          ]
              .where((contractScores) => contractsTest
                  .map((ContractsInfo? contract) => contract?.name)
                  .contains(contractScores.name))
              .toList(),
        );

        final contractsManager =
            ContractsManager(mockStorage, playerNames.length);

        expect(contractsManager.scoresByContract(player), {
          ContractsInfo.barbu:
              contractsTest.contains(ContractsInfo.barbu) ? barbuScores : null,
          ContractsInfo.noHearts: contractsTest.contains(ContractsInfo.noHearts)
              ? noHeartsScores
              : null,
          ContractsInfo.noQueens: contractsTest.contains(ContractsInfo.noQueens)
              ? noQueensScores
              : null,
          ContractsInfo.noTricks: contractsTest.contains(ContractsInfo.noTricks)
              ? noTricksScores
              : null,
          ContractsInfo.noLastTrick:
              contractsTest.contains(ContractsInfo.noLastTrick)
                  ? noLastTricksScores
                  : null,
          ContractsInfo.domino: contractsTest.contains(ContractsInfo.domino)
              ? dominoScores
              : null,
          ContractsInfo.trumps: contractsTest.contains(ContractsInfo.trumps)
              ? trumpsScores
              : null,
        });
      });
    }
  });

  group("#sumScoresByContract", () {
    test("should sum scores when all players have all contracts", () {
      final players = playerNames
          .map(
            (name) => Player(
              name: name,
              color: PlayerColors.values[0],
              image: playerImages[0],
              contracts: [
                barbu,
                noQueens,
                noHearts,
                noLastTrick,
                noTricks,
                domino,
                trumps
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
        ContractsInfo.trumps: trumpsScores.map(
          (player, score) => MapEntry(player, score * players.length),
        ),
      });
    });
    test("should sum scores when players have some contracts", () {
      final players = [
        Player(
          name: playerNames[0],
          color: PlayerColors.values[0],
          image: playerImages[0],
          contracts: [barbu, noQueens, noHearts],
        ),
        Player(
          name: playerNames[1],
          color: PlayerColors.values[1],
          image: playerImages[1],
          contracts: [barbu, noHearts, noLastTrick],
        ),
        Player(
          name: playerNames[2],
          color: PlayerColors.values[2],
          image: playerImages[2],
          contracts: [barbu, noHearts, noTricks],
        ),
        Player(
          name: playerNames[3],
          color: PlayerColors.values[3],
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
        ContractsInfo.trumps: null,
      });
    });
  });
}
