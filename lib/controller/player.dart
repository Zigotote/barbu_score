import 'package:get/get.dart';

import 'contract.dart';

/// A player for a party
class PlayerController extends GetxController {
  /// The id of the player
  final int id;

  /// The observable name of the player
  RxString _name;

  /// The contracts the player has finished
  List<Contract> contracts;

  PlayerController(this.id) {
    this._name = "".obs;
  }

  String get name => _name.value;

  set name(value) => _name.value = value;

  /// Returns the list of the contracts the player can choose
  List<ContractsNames> get availableContracts => ContractsNames.values
      .where((contractName) => !choosenContracts.contains(contractName));

  /// Returns the list of the contracts the player has already selected
  List<ContractsNames> get choosenContracts =>
      contracts.map((contract) => contract.name);

  @override
  String toString() => _name.value;
}
