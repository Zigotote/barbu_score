import 'package:barbu_score/theme/my_theme_colors.dart';

import '../../main.dart';
import 'contract_settings_models.dart';

/// List the names of the contracts for a game
enum ContractsInfo {
  barbu(
    settingsRoute: "${Routes.onLooserSettings}/barbu",
    color: MyThemeColors.brown,
  ),
  noHearts(
    settingsRoute: "${Routes.noSomethingScoresSettings}/noHearts",
    color: MyThemeColors.red,
  ),
  noQueens(
    settingsRoute: "${Routes.noSomethingScoresSettings}/noQueens",
    color: MyThemeColors.orange,
  ),
  noTricks(
    settingsRoute: "${Routes.noSomethingScoresSettings}/noTricks",
    color: MyThemeColors.blueGreen,
  ),
  noLastTrick(
    settingsRoute: "${Routes.onLooserSettings}/noLastTrick",
    color: MyThemeColors.darkBlue,
  ),
  salad(
    settingsRoute: Routes.saladSettings,
    color: MyThemeColors.green,
  ),
  domino(
    settingsRoute: Routes.dominoSettings,
    color: MyThemeColors.purple,
  );

  const ContractsInfo({
    required this.settingsRoute,
    required this.color,
  });

  final String settingsRoute;
  final MyThemeColors color;

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
        // TODO Océane migrer les settings personnalisés déjà sauvegardées pour ajouter +6 joueurs
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
