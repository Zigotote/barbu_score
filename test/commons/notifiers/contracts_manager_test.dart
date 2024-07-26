import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/notifiers/contracts_manager.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';
import '../../utils.mocks.dart';

main() {
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
  final trumps = TrumpsContractModel();
  for (var subContract in [barbu, noQueens, noHearts, noLastTrick, noTricks]) {
    trumps.addSubContract(subContract);
  }
  for (var contractsTest in [
    <ContractsInfo?>[],
    <ContractsInfo>[ContractsInfo.barbu],
    <ContractsInfo>[
      ContractsInfo.barbu,
      ContractsInfo.noQueens,
      ContractsInfo.domino
    ],
    <ContractsInfo>[
      ContractsInfo.barbu,
      ContractsInfo.noHearts,
      ContractsInfo.noQueens,
      ContractsInfo.noTricks,
      ContractsInfo.noLastTrick,
      ContractsInfo.domino,
      ContractsInfo.trumps,
    ]
  ]) {
    test("should calculate scores by contract for a player with $contractsTest",
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
      final mockStorage = MockMyStorage2();
      mockActiveContracts(mockStorage);

      final contractsManager =
          ContractsManager(mockStorage, playerNames.length);

      expect(contractsManager.scoresByContract(player), {
        ContractsInfo.barbu: contractsTest.contains(ContractsInfo.barbu)
            ? {
                for (var (index, player) in playerNames.indexed)
                  player: index == 0 ? 50 : 0
              }
            : null,
        ContractsInfo.noHearts: contractsTest.contains(ContractsInfo.noHearts)
            ? {for (var player in playerNames) player: 10}
            : null,
        ContractsInfo.noQueens: contractsTest.contains(ContractsInfo.noQueens)
            ? {for (var player in playerNames) player: 10}
            : null,
        ContractsInfo.noTricks: contractsTest.contains(ContractsInfo.noTricks)
            ? {for (var player in playerNames) player: 10}
            : null,
        ContractsInfo.noLastTrick:
            contractsTest.contains(ContractsInfo.noLastTrick)
                ? {
                    for (var (index, player) in playerNames.indexed)
                      player: index == 0 ? 40 : 0
                  }
                : null,
        ContractsInfo.domino: contractsTest.contains(ContractsInfo.domino)
            ? {
                for (var (index, player) in playerNames.indexed)
                  player: (ContractsInfo.domino.defaultSettings
                          as DominoContractSettings)
                      .points[playerNames.length]?[index]
              }
            : null,
        ContractsInfo.trumps: contractsTest.contains(ContractsInfo.trumps)
            ? {
                for (var (index, player) in playerNames.indexed)
                  player: index == 0 ? 120 : 30
              }
            : null,
      });
    });
  }
}
