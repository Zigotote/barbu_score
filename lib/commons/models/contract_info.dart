import 'package:barbu_score/theme/my_theme_colors.dart';

import '../../main.dart';
import 'contract_settings_models.dart';

/// List the names of the contracts for a game
enum ContractsInfo {
  barbu(
    color: MyThemeColors.brown,
    settingsRoute: "${Routes.contractWithPointsSettings}/barbu",
  ),
  noHearts(
    color: MyThemeColors.red,
    settingsRoute: "${Routes.contractWithPointsSettings}/noHearts",
  ),
  noQueens(
    color: MyThemeColors.orange,
    settingsRoute: "${Routes.contractWithPointsSettings}/noQueens",
  ),
  noTricks(
    color: MyThemeColors.blueGreen,
    settingsRoute: "${Routes.contractWithPointsSettings}/noTricks",
  ),
  noLastTrick(
    color: MyThemeColors.darkBlue,
    settingsRoute: "${Routes.contractWithPointsSettings}/noLastTrick",
  ),
  salad(
    color: MyThemeColors.green,
    settingsRoute: Routes.saladSettings,
  ),
  domino(
    color: MyThemeColors.purple,
    settingsRoute: Routes.dominoSettings,
  );

  final MyThemeColors color;
  final String settingsRoute;

  const ContractsInfo({
    required this.color,
    required this.settingsRoute,
  });

  AbstractContractSettings get defaultSettings {
    switch (this) {
      case ContractsInfo.barbu:
        return ContractWithPointsSettings(contract: this, points: 50);
      case ContractsInfo.noHearts:
        return ContractWithPointsSettings(
          contract: this,
          points: 5,
          invertScore: true,
        );
      case ContractsInfo.noQueens:
        return ContractWithPointsSettings(
          contract: this,
          points: 10,
          invertScore: true,
        );
      case ContractsInfo.noTricks:
        return ContractWithPointsSettings(
          contract: this,
          points: 5,
          invertScore: true,
        );
      case ContractsInfo.noLastTrick:
        return ContractWithPointsSettings(contract: this, points: 40);
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
    return ContractsInfo.values.firstWhere(
      (contract) => contract.name == name,
      // TODO Temporary to migrate trumps settings to salad settings
      orElse: () => ContractsInfo.salad,
    );
  }
}
