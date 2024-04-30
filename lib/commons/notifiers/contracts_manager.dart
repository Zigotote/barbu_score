import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contract_info.dart';
import '../models/contract_models.dart';
import '../models/contract_settings_models.dart';
import '../models/player.dart';
import 'play_game.dart';
import 'storage.dart';

final contractsManagerProvider = StateProvider.autoDispose<ContractsManager>(
  (ref) => ContractsManager(
    ref.read(storageProvider),
    ref.read(playGameProvider).game.players.length,
  ),
);

/// A class to bind all contracts data together
class ContractManager {
  final AbstractContractModel model;
  final AbstractContractSettings settings;

  ContractManager({required this.model, required this.settings});
}

/// A class to manage the contracts of the game
class ContractsManager {
  late final Map<ContractsInfo, ContractManager> _contracts;

  ContractsManager(MyStorage2 storage, int nbPlayers) {
    _contracts = {
      ContractsInfo.barbu: ContractManager(
        model: OneLooserContractModel(contract: ContractsInfo.barbu),
        settings: storage.getSettings(ContractsInfo.barbu),
      ),
      ContractsInfo.noHearts: ContractManager(
        model: MultipleLooserContractModel(
          contract: ContractsInfo.noHearts,
          nbItems: nbPlayers * 2,
        ),
        settings: storage.getSettings(ContractsInfo.noHearts),
      ),
      ContractsInfo.noQueens: ContractManager(
        model: MultipleLooserContractModel(
          contract: ContractsInfo.noQueens,
          nbItems: 4,
        ),
        settings: storage.getSettings(ContractsInfo.noQueens),
      ),
      ContractsInfo.noTricks: ContractManager(
        model: MultipleLooserContractModel(
          contract: ContractsInfo.noTricks,
          nbItems: 8,
        ),
        settings: storage.getSettings(ContractsInfo.noTricks),
      ),
      ContractsInfo.noLastTrick: ContractManager(
        model: OneLooserContractModel(contract: ContractsInfo.noLastTrick),
        settings: storage.getSettings(ContractsInfo.noLastTrick),
      ),
      ContractsInfo.trumps: ContractManager(
        model: TrumpsContractModel(),
        settings: storage.getSettings(ContractsInfo.trumps),
      ),
      ContractsInfo.domino: ContractManager(
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

  /// Returns the scores of the players, for each contract played by the [player]
  Map<ContractsInfo, Map<String, int>?> scoresByContract(Player player) {
    return Map.fromEntries(
      _contracts.entries.where((contract) => contract.value.settings.isActive),
    ).map(
      (contract, contractManager) => MapEntry(
        contract,
        player.contractScores(contract, contractManager.settings),
      ),
    );
  }

  /// Returns the contract model and settings for one specific contract
  ContractManager getContractManager(ContractsInfo contract) =>
      _contracts[contract]!;
}
