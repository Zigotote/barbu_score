import '../main.dart';
import '../models/contract_models.dart';

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
      case ContractsNames.Domino:
        return Routes.DOMINO_SCORES;
      case ContractsNames.Trumps:
        return Routes.TRUMPS_SCORES;
      default:
        return Routes.NO_SOMETHING_SCORES;
    }
  }

  /// Returns the ContractModel object to save the scores of the contract
  AbstractContractModel get contract {
    switch (this) {
      case ContractsNames.Barbu:
        return BarbuContractModel();
      case ContractsNames.NoHearts:
        return NoHeartsContractModel();
      case ContractsNames.NoQueens:
        return NoQueensContractModel();
      case ContractsNames.NoTricks:
        return NoTricksContractModel();
      case ContractsNames.NoLastTrick:
        return NoLastTrickContractModel();
      case ContractsNames.Trumps:
        return TrumpsContractModel();
      case ContractsNames.Domino:
        return DominoContractModel();
    }
    return null;
  }
}
