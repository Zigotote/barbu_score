import '../main.dart';
import '../models/contract_models.dart';

/// List the names of the contracts for a party
enum ContractsNames {
  Barbu("Barbu", Routes.BARBU_OR_NOLASTTRICK_SCORES),
  NoHearts("Sans coeurs", Routes.NO_SOMETHING_SCORES),
  NoQueens("Sans dames", Routes.NO_SOMETHING_SCORES),
  NoTricks("Sans plis", Routes.NO_SOMETHING_SCORES),
  NoLastTrick("Dernier", Routes.BARBU_OR_NOLASTTRICK_SCORES),
  Trumps("Salade", Routes.TRUMPS_SCORES),
  Domino("Réussite", Routes.DOMINO_SCORES);

  const ContractsNames(this.displayName, this.route);

  final String displayName;
  final String route;

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
  }

  // Returns the contract associated with the enum value obtained with toString()
  static AbstractContractModel getContractFromToString(String enumName) {
    return ContractsNames.values
        .firstWhere((contract) => contract.toString() == enumName)
        .contract;
  }
}
