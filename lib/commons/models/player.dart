import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'contract_info.dart';
import 'contract_models.dart';

class Player {
  /// The color of the player
  Color color;

  /// The image of the player
  String image;

  /// The name of the player
  String name;

  /// The contracts the player has finished
  final List<AbstractContractModel> _contracts;

  Player({required this.color, required this.image, this.name = ""})
      : _contracts = [];

  /// Returns the list of the contracts the player has already selected
  List<String> get _choosenContracts =>
      _contracts.map((contract) => contract.name).toList();

  /// Returns the list of the contracts the player can choose
  List<ContractsInfo> get availableContracts => ContractsInfo.values
      .where((contract) => !_choosenContracts.contains(contract.name))
      .toList();

  /// Returns the scores of each player, for the contracts of this player
  /// If the player has not played contracts it return null
  Map<String, int>? get playerScores {
    if (_contracts.isEmpty) {
      return null;
    }
    return AbstractContractModel.calculateTotalScore(_contracts);
  }

  /// Returns true if the player has played the contract
  bool hasPlayedContract(ContractsInfo contract) {
    return _choosenContracts.contains(contract.name);
  }

  /// Adds a contract played by a player, created from its name.
  /// The score is calculated from the Map wich links the number of card or trick each player won.
  /// Returns true if the score has been added, false otherwise
  bool addContract(ContractsInfo contractName, Map<String, int> trickByPlayer) {
    AbstractContractModel contract = contractName.contract;
    final bool isValidScore = contract.setScores(trickByPlayer);
    if (isValidScore) {
      _contracts.removeWhere((c) => c.name == contractName.name);
      _contracts.add(contract);
    }
    return isValidScore;
  }

  /// Returns the scores for the contract. Returns null if it has not been played
  Map<String, int>? contractScores(String contractName) {
    final AbstractContractModel? contract = _contracts
        .firstWhereOrNull((contract) => contract.name == contractName);
    return contract?.scores;
  }
}
