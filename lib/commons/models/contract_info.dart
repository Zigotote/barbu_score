import 'package:barbu_score/theme/my_theme_colors.dart';

import 'contract_settings_models.dart';

/// List the names of the contracts for a game
enum ContractsInfo {
  barbu(color: MyThemeColors.brown),
  noHearts(color: MyThemeColors.red),
  noQueens(color: MyThemeColors.orange),
  noTricks(color: MyThemeColors.blueGreen),
  noLastTrick(color: MyThemeColors.darkBlue),
  salad(color: MyThemeColors.green),
  trumps(color: MyThemeColors.yellow),
  domino(color: MyThemeColors.purple);

  final MyThemeColors color;

  const ContractsInfo({required this.color});

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
              contract.name: true,
          },
        );
      case ContractsInfo.trumps:
        return ContractWithPointsSettings(
          contract: this,
          points: -5,
          isActive: false,
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
