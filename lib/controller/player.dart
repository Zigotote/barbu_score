import 'package:get/get.dart';

import 'contract.dart';

/// A player for a party
class PlayerController extends GetxController {
  /// The id of the player
  final int id;

  /// The observable name of the player
  RxString _name;

  /// The contracts the player has finished
  List<ContractController> contracts;

  PlayerController(this.id) {
    this._name = "".obs;
    this.contracts = [];
  }

  String get name => _name.value;

  set name(value) => _name.value = value;

  /// Returns the list of the contracts the player can choose
  List<ContractsNames> get availableContracts => ContractsNames.values
      .where((contractName) => !choosenContracts.contains(contractName))
      .toList();

  /// Returns the list of the contracts the player has already selected
  List<ContractsNames> get choosenContracts =>
      contracts.map((contract) => contract.name).toList();

  /// Adds a contract for the player, with the scores of each players
  void addContract(ContractsNames contract, Map<PlayerController, int> scores) {
    contracts.add(ContractController(contract, scores));
  }

  @override
  String toString() => _name.value;
}
