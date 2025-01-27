import 'package:hive/hive.dart';

import '../../main.dart';
import 'contract_settings_models.dart';

part 'contract_info.g.dart';

/// List the names of the contracts for a party
@HiveType(typeId: 13)
enum ContractsInfo {
  @HiveField(0)
  barbu(
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  ),
  @HiveField(1)
  noHearts(
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(2)
  noQueens(
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(3)
  noTricks(
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(4)
  noLastTrick(
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  ),
  @HiveField(5)
  trumps(
    scoreRoute: Routes.trumpsScores,
    settingsRoute: Routes.trumpsSettings,
  ),
  @HiveField(6)
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
      case ContractsInfo.trumps:
        return TrumpsContractSettings(
          contracts: {
            for (var contract in TrumpsContractSettings.availableContracts)
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
