import '../../main.dart';
import 'contract_models.dart';

/// List the names of the contracts for a party
enum ContractsInfo {
  Barbu("Barbu", Routes.BARBU_OR_NOLASTTRICK_SCORES),
  NoHearts("Sans coeurs", Routes.NO_SOMETHING_SCORES),
  NoQueens("Sans dames", Routes.NO_SOMETHING_SCORES),
  NoTricks("Sans plis", Routes.NO_SOMETHING_SCORES),
  NoLastTrick("Dernier", Routes.BARBU_OR_NOLASTTRICK_SCORES),
  Trumps("Salade", Routes.TRUMPS_SCORES),
  Domino("Réussite", Routes.DOMINO_SCORES);

  const ContractsInfo(this.displayName, this.route);

  final String displayName;
  final String route;

  AbstractContractModel get contract {
    switch (this) {
      case ContractsInfo.Barbu:
        return BarbuContractModel();
      case ContractsInfo.NoHearts:
        return NoHeartsContractModel();
      case ContractsInfo.NoQueens:
        return NoQueensContractModel();
      case ContractsInfo.NoTricks:
        return NoTricksContractModel();
      case ContractsInfo.NoLastTrick:
        return NoLastTrickContractModel();
      case ContractsInfo.Trumps:
        return TrumpsContractModel();
      case ContractsInfo.Domino:
        return DominoContractModel();
    }
  }

  // Returns the contract associated with the enum value obtained with toString()
  static AbstractContractModel getContractFromToString(String enumName) {
    return ContractsInfo.values
        .firstWhere((contract) => contract.name == enumName)
        .contract;
  }
}
