import 'package:get/get.dart';

import 'player.dart';

/// List the names of the contracts for a party
enum ContractsNames {
  Barbu,
  NoHearts,
  NoQueens,
  NoTricks,
  NoLastTrick,
  Trumps,
  Domino
}

extension ContractsInfos on ContractsNames {
  int maximumScore(int nbPlayers) {
    switch (this) {
      case ContractsNames.Barbu:
        return 50;
      case ContractsNames.NoHearts:
        return nbPlayers * 2 * 5;
      case ContractsNames.NoQueens:
        return 40;
      case ContractsNames.NoTricks:
        return 40;
      case ContractsNames.NoLastTrick:
        return 40;
      case ContractsNames.Trumps:
        return 50 + 40 * 3 + (nbPlayers * 2 * 5);
      case ContractsNames.Domino:
        return 0;
    }
    return 0;
  }

  /// Returns the name to display for the different contracts
  String displayName() {
    switch (this) {
      case ContractsNames.Barbu:
        return "Barbu";
      case ContractsNames.NoHearts:
        return "Sans coeurs";
      case ContractsNames.NoQueens:
        return "Sans dames";
      case ContractsNames.NoTricks:
        return "Sans plis";
      case ContractsNames.NoLastTrick:
        return "Dernier";
      case ContractsNames.Trumps:
        return "Salade";
      case ContractsNames.Domino:
        return "Réussite";
    }
    return "";
  }
}

/// A specific contract scores
class ContractController extends GetxController {
  /// The name of the contract
  final ContractsNames name;

  /// The scores of all the players for this contract
  final Map<PlayerController, int> scores;

  ContractController(this.name, this.scores);
}
