import 'package:get/get.dart';

import '../controller/party.dart';
import '../main.dart';
import '../controller/player.dart';

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
  /// Returns the maximal score for a contract
  int get maximalScore {
    int nbPlayers = Get.find<PartyController>().nbPlayers;
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
  String get displayName {
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

  /// Returns the route to fill the scores of the contract
  String get route {
    switch (this) {
      case ContractsNames.Barbu:
        return Routes.BARBU_OR_NOLASTTRICK_SCORES;
      case ContractsNames.NoLastTrick:
        return Routes.BARBU_OR_NOLASTTRICK_SCORES;
      default:
        return Routes.CONTRACT_SCORES;
    }
  }
}

/// A specific contract scores
class ContractModel {
  /// The name of the contract
  final ContractsNames name;

  /// The scores of all the players for this contract
  final Map<PlayerController, int> scores;

  ContractModel(this.name, this.scores);
}
