import 'contract.dart';

/// A player for a party
class Player {
  /// The name of the player
  final String name;

  /// The contracts he has finished
  List<Contract> contracts;

  Player(this.name);

  /// Returns the list of the contracts the player can choose
  List<ContractsNames> get availableContracts => ContractsNames.values
      .where((contractName) => !choosenContracts.contains(contractName));

  /// Returns the list of the contracts the player has already selected
  List<ContractsNames> get choosenContracts =>
      contracts.map((contract) => contract.name);
}
