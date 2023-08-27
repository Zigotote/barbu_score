import 'package:barbu_score/commons/models/domino_points_props.dart';

import '../../main.dart';
import 'contract_models.dart';

/// List the names of the contracts for a party
enum ContractsInfo {
  barbu(
    displayName: "Barbu",
    defaultPoints: 50,
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  ),
  noHearts(
    displayName: "Sans coeurs",
    defaultPoints: 5,
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  noQueens(
    displayName: "Sans dames",
    defaultPoints: 10,
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  noTricks(
    displayName: "Sans plis",
    defaultPoints: 5,
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  noLastTrick(
    displayName: "Dernier",
    defaultPoints: 40,
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  trumps(displayName: "Salade", scoreRoute: Routes.trumpsScores),
  domino(
    displayName: "Réussite",
    defaultPoints: DominoPointsProps(
      isFix: false,
      points: [-40, -20, -10, 10, 20, 40],
    ),
    scoreRoute: Routes.dominoScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  );

  const ContractsInfo(
      {required this.displayName,
      this.defaultPoints,
      required this.scoreRoute,
      this.settingsRoute});

  final String displayName;
  final dynamic defaultPoints;
  final String scoreRoute;
  final String? settingsRoute;

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
