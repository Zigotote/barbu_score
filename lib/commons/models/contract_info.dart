import 'package:barbu_score/commons/models/domino_points_props.dart';

import '../../main.dart';
import 'contract_models.dart';

/// List the names of the contracts for a party
enum ContractsInfo {
  barbu("Barbu", 50, Routes.barbuOrNoLastTrickScores),
  noHearts("Sans coeurs", 5, Routes.noSomethingScores),
  noQueens("Sans dames", 10, Routes.noSomethingScores),
  noTricks("Sans plis", 5, Routes.noSomethingScores),
  noLastTrick("Dernier", 40, Routes.barbuOrNoLastTrickScores),
  trumps("Salade", null, Routes.trumpsScores),
  domino(
      "Réussite",
      DominoPointsProps(
        isFix: false,
        points: [-40, -20, -10, 10, 20, 40],
      ),
      Routes.dominoScores);

  const ContractsInfo(this.displayName, this.defaultPoints, this.route);

  final String displayName;
  final dynamic defaultPoints;
  final String route;

  AbstractContractModel get contract {
    switch (this) {
      case ContractsInfo.barbu:
        return OneLooserContractModel(ContractsInfo.barbu);
      case ContractsInfo.noHearts:
        return NoHeartsContractModel();
      case ContractsInfo.noQueens:
        return NoQueensContractModel();
      case ContractsInfo.noTricks:
        return NoTricksContractModel();
      case ContractsInfo.noLastTrick:
        return OneLooserContractModel(ContractsInfo.noLastTrick);
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
