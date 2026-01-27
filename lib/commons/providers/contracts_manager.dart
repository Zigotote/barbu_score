import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../models/contract_info.dart';
import '../models/contract_models.dart';
import '../models/contract_settings_models.dart';
import '../models/player.dart';
import 'play_game.dart';
import 'storage.dart';

final contractsManagerProvider = StateProvider.autoDispose<ContractsManager>(
  (ref) => ContractsManager(
    ref.watch(storageProvider),
    ref.watch(playGameProvider).game.players.length,
  ),
);

/// An object to bind all contracts data together
typedef ContractManager = ({
  AbstractContractModel model,
  AbstractContractSettings settings,
});

/// A class to manage the contracts of the game
class ContractsManager {
  late final Map<ContractsInfo, ContractManager> _contracts;
  late final int _nbDecks;

  ContractsManager(MyStorage storage, int nbPlayers) {
    final gameSettings = storage.getGameSettings();
    _nbDecks = gameSettings.getNbDecks(nbPlayers);
    _contracts = {
      ContractsInfo.barbu: (
        model: ContractWithPointsModel(
          contract: ContractsInfo.barbu,
          nbItems: _nbDecks,
        ),
        settings: storage.getSettings(ContractsInfo.barbu),
      ),
      ContractsInfo.noHearts: (
        model: ContractWithPointsModel(
          contract: ContractsInfo.noHearts,
          nbItems: nbPlayers * 2,
        ),
        settings: storage.getSettings(ContractsInfo.noHearts),
      ),
      ContractsInfo.noQueens: (
        model: ContractWithPointsModel(
          contract: ContractsInfo.noQueens,
          nbItems: gameSettings.getCardsToKeep(nbPlayers)[12] ?? _nbDecks * 4,
        ),
        settings: storage.getSettings(ContractsInfo.noQueens),
      ),
      ContractsInfo.noTricks: (
        model: ContractWithPointsModel(
          contract: ContractsInfo.noTricks,
          nbItems: gameSettings.getNbTricksByRound(nbPlayers),
        ),
        settings: storage.getSettings(ContractsInfo.noTricks),
      ),
      ContractsInfo.noLastTrick: (
        model: ContractWithPointsModel(
          contract: ContractsInfo.noLastTrick,
          nbItems: 1,
        ),
        settings: storage.getSettings(ContractsInfo.noLastTrick),
      ),
      ContractsInfo.salad: (
        model: SaladContractModel(),
        settings: storage.getSettings(ContractsInfo.salad),
      ),
      ContractsInfo.domino: (
        model: DominoContractModel(),
        settings: storage.getSettings(ContractsInfo.domino),
      ),
    };
  }

  /// Returns all the contracts models and settings for the game
  UnmodifiableMapView<ContractsInfo, ContractManager> get contracts =>
      UnmodifiableMapView(_contracts);

  /// Returns the active contracts for the game
  UnmodifiableListView<ContractsInfo> get activeContracts =>
      UnmodifiableListView(
        _contracts.entries
            .where((contract) => contract.value.settings.isActive)
            .map((contract) => contract.key)
            .toList(),
      );

  String getScoresRoute(ContractsInfo contract) {
    return switch (contract) {
      ContractsInfo.barbu =>
        _nbDecks == 1
            ? "${Routes.oneLooserScores}/${contract.name}"
            : "${Routes.noSomethingScores}/${contract.name}",
      ContractsInfo.noHearts ||
      ContractsInfo.noQueens ||
      ContractsInfo.noTricks => "${Routes.noSomethingScores}/${contract.name}",
      ContractsInfo.noLastTrick => "${Routes.oneLooserScores}/${contract.name}",
      ContractsInfo.salad => Routes.saladScores,
      ContractsInfo.domino => Routes.dominoScores,
    };
  }

  /// Returns the scores of the players, for each contract played by the [player]
  Map<ContractsInfo, Map<String, int>?> scoresByContract(Player player) {
    return Map.fromEntries(
      _contracts.entries.where((contract) => contract.value.settings.isActive),
    ).map((contract, contractManager) {
      Map<String, int>? scores;
      final AbstractContractModel? contractModel = player.contracts
          .firstWhereOrNull((c) => c.name == contract.name);
      if (contractModel is SaladContractModel) {
        scores = contractModel.scores(
          contractManager.settings,
          _contracts.values
              .map((contractManager) => contractManager.settings)
              .toList(),
        );
      } else {
        scores = contractModel?.scores(contractManager.settings);
      }
      return MapEntry(contract, scores);
    });
  }

  /// Sums the scores of the players, sorted by contract
  Map<ContractsInfo, Map<String, int>?> sumScoresByContract(
    List<Player> players,
  ) {
    return players
        .map((player) => scoresByContract(player))
        .reduce(
          (sum, contractScores) => sum
            ..updateAll(
              (contract, playerScores) => playerScores == null
                  ? contractScores[contract]
                  : (playerScores..updateAll(
                      (player, score) =>
                          score + (contractScores[contract]?[player] ?? 0),
                    )),
            ),
        );
  }

  /// Returns the contract model and settings for one specific contract
  ContractManager getContractManager(ContractsInfo contract) =>
      _contracts[contract]!;
}
