import '../../main.dart';
import 'contract_settings_models.dart';

/// List the names of the contracts for a game
enum ContractsInfo {
  barbu(
    scoreRoute: "${Routes.barbuOrNoLastTrickScores}/barbu",
    settingsRoute: "${Routes.barbuOrNoLastTrickSettings}/barbu",
  ),
  noHearts(
    scoreRoute: "${Routes.noSomethingScores}/noHearts",
    settingsRoute: "${Routes.noSomethingScoresSettings}/noHearts",
  ),
  noQueens(
    scoreRoute: "${Routes.noSomethingScores}/noQueens",
    settingsRoute: "${Routes.noSomethingScoresSettings}/noQueens",
  ),
  noTricks(
    scoreRoute: "${Routes.noSomethingScores}/noTricks",
    settingsRoute: "${Routes.noSomethingScoresSettings}/noTricks",
  ),
  noLastTrick(
    scoreRoute: "${Routes.barbuOrNoLastTrickScores}/noLastTrick",
    settingsRoute: "${Routes.barbuOrNoLastTrickSettings}/noLastTrick",
  ),
  salad(
    scoreRoute: Routes.saladScores,
    settingsRoute: Routes.saladSettings,
  ),
  domino(
    scoreRoute: Routes.dominoScores,
    settingsRoute: Routes.dominoSettings,
  );

  const ContractsInfo({required this.scoreRoute, required this.settingsRoute});

  final String scoreRoute;
  final String settingsRoute;

  AbstractContractSettings get defaultSettings {
    switch (this) {
      case ContractsInfo.barbu:
        return OneLooserContractSettings(contract: this, points: 50);
      case ContractsInfo.noHearts:
        return MultipleLooserContractSettings(contract: this, points: 5);
      case ContractsInfo.noQueens:
        return MultipleLooserContractSettings(contract: this, points: 10);
      case ContractsInfo.noTricks:
        return MultipleLooserContractSettings(contract: this, points: 5);
      case ContractsInfo.noLastTrick:
        return OneLooserContractSettings(contract: this, points: 40);
      case ContractsInfo.salad:
        return SaladContractSettings(
          contracts: {
            for (var contract in SaladContractSettings.availableContracts)
              contract.name: true
          },
        );
      case ContractsInfo.domino:
        return DominoContractSettings(
          pointsFirstPlayer: -40,
          pointsLastPlayer: 40,
        );
    }
  }

  /// Returns the ContractsInfo from its name
  static ContractsInfo fromName(String name) {
    return ContractsInfo.values.firstWhere((contract) => contract.name == name);
  }
}
