import '../../main.dart';
import 'contract_models.dart';
import 'contract_settings_models.dart';

/// List the names of the contracts for a party
enum ContractsInfo {
  barbu(
    displayName: "Barbu",
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  ),
  noHearts(
    displayName: "Sans coeurs",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  noQueens(
    displayName: "Sans dames",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  noTricks(
    displayName: "Sans plis",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  noLastTrick(
    displayName: "Dernier",
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  trumps(displayName: "Salade", scoreRoute: Routes.trumpsScores),
  domino(
    displayName: "Réussite",
    scoreRoute: Routes.dominoScores,
    settingsRoute: Routes.dominoSettings,
  );

  const ContractsInfo(
      {required this.displayName,
      required this.scoreRoute,
      this.settingsRoute});

  final String displayName;
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

  AbstractContractSettings get settings {
    switch (this) {
      case ContractsInfo.barbu:
        return PointsContractSettings(points: 50);
      case ContractsInfo.noHearts:
        return IndividualScoresContractSettings(points: 5);
      case ContractsInfo.noQueens:
        return IndividualScoresContractSettings(points: 10);
      case ContractsInfo.noTricks:
        return IndividualScoresContractSettings(points: 10);
      case ContractsInfo.noLastTrick:
        return PointsContractSettings(points: 50);
      case ContractsInfo.trumps:
        return TrumpsContractSettings();
      case ContractsInfo.domino:
        return DominoContractSettings(pointsMin: -40, pointsMax: 40);
    }
  }

  // Returns the contract associated with the enum value obtained with toString()
  static AbstractContractModel getContractFromToString(String enumName) {
    return ContractsInfo.values
        .firstWhere((contract) => contract.name == enumName)
        .contract;
  }
}
