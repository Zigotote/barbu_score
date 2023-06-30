import '../../main.dart';
import 'contract_models.dart';

/// List the names of the contracts for a party
enum ContractsInfo {
  barbu("Barbu", Routes.barbuOrNoLastTrickScores),
  noHearts("Sans coeurs", Routes.noSomethingScores),
  noQueens("Sans dames", Routes.noSomethingScores),
  noTricks("Sans plis", Routes.noSomethingScores),
  noLastTrick("Dernier", Routes.barbuOrNoLastTrickScores),
  trumps("Salade", Routes.trumpsScores),
  domino("Réussite", Routes.dominoScores);

  const ContractsInfo(this.displayName, this.route);

  final String displayName;
  final String route;

  AbstractContractModel get contract {
    switch (this) {
      case ContractsInfo.barbu:
        return BarbuContractModel();
      case ContractsInfo.noHearts:
        return NoHeartsContractModel();
      case ContractsInfo.noQueens:
        return NoQueensContractModel();
      case ContractsInfo.noTricks:
        return NoTricksContractModel();
      case ContractsInfo.noLastTrick:
        return NoLastTrickContractModel();
      case ContractsInfo.trumps:
        return TrumpsContractModel();
      case ContractsInfo.domino:
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
