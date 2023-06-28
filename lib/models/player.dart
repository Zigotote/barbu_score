import 'package:flutter/material.dart';

import '../pages/play_game/models/contract_info.dart';
import '../pages/play_game/models/contract_models.dart';

class Player {
  /// The color of the player
  Color color;

  /// The image of the player
  String image;

  /// The name of the player
  String name;

  /// The contracts the player has finished
  List<AbstractContractModel> _contracts;

  Player({required this.color, required this.image, this.name = ""})
      : _contracts = [];

  /// Returns the list of the contracts the player has already selected
  List<String> get _choosenContracts =>
      _contracts.map((contract) => contract.name).toList();

  /// Returns the list of the contracts the player can choose
  List<ContractsInfo> get availableContracts => ContractsInfo.values
      .where((contract) => !_choosenContracts.contains(contract.name))
      .toList();

  /// Returns true if the player has played the contract
  bool hasPlayedContract(ContractsInfo contract) {
    return _choosenContracts.contains(contract.name);
  }

  /// Adds a contract played by a player, created from its name.
  /// The score is calculated from the Map wich links the number of card or trick each player won.
  /// Returns true if the score has been added, false otherwise
  bool addContract(ContractsInfo contractName, Map<String, int> trickByPlayer) {
    AbstractContractModel contract = contractName.contract;
    final bool isValidScore = contract.calculateScores(trickByPlayer);
    if (isValidScore) {
      _contracts.removeWhere((c) => c.name == contractName.name);
      _contracts.add(contract);
    }
    return isValidScore;
  }
}
