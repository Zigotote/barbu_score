import 'package:hive/hive.dart';

import '../../main.dart';
import 'contract_models.dart';
import 'contract_settings_models.dart';

part 'contract_info.g.dart';

/// List the names of the contracts for a party
@HiveType(typeId: 13)
enum ContractsInfo {
  @HiveField(0)
  barbu(
    displayName: "Barbu",
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  ),
  @HiveField(1)
  noHearts(
    displayName: "Sans coeurs",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(2)
  noQueens(
    displayName: "Sans dames",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(3)
  noTricks(
    displayName: "Sans plis",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(4)
  noLastTrick(
    displayName: "Dernier",
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  ),
  @HiveField(5)
  trumps(
    displayName: "Salade",
    scoreRoute: Routes.trumpsScores,
    settingsRoute: Routes.trumpsSettings,
  ),
  @HiveField(6)
  domino(
    displayName: "Réussite",
    scoreRoute: Routes.dominoScores,
    settingsRoute: Routes.dominoSettings,
  );

  const ContractsInfo(
      {required this.displayName,
      required this.scoreRoute,
      required this.settingsRoute});

  final String displayName;
  final String scoreRoute;
  final String settingsRoute;

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
        return PointsContractSettings(points: 40);
      case ContractsInfo.trumps:
        return TrumpsContractSettings(
          contracts: Map.fromIterable(
            TrumpsContractSettings.availableContracts,
            value: (contract) => contract != ContractsInfo.domino,
          ),
        );
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
