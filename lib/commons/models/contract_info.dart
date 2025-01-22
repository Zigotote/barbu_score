import 'package:hive/hive.dart';

import '../../main.dart';
import 'contract_settings_models.dart';

part 'contract_info.g.dart';

/// List the names of the contracts for a party
@HiveType(typeId: 13)
enum ContractsInfo {
  @HiveField(0)
  barbu(
    displayName: "Barbu",
    rules: "Le joueur emportant le roi de coeur (Barbu) marque %d points.",
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  ),
  @HiveField(1)
  noHearts(
    displayName: "Sans coeurs",
    rules: "Chaque joueur marque %d points par coeur remporté.",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(2)
  noQueens(
    displayName: "Sans dames",
    rules: "Chaque joueur marque %d points par dame remportée.",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(3)
  noTricks(
    displayName: "Sans plis",
    rules: "Chaque joueur marque %d points par pli remporté.",
    scoreRoute: Routes.noSomethingScores,
    settingsRoute: Routes.noSomethingScoresSettings,
  ),
  @HiveField(4)
  noLastTrick(
    displayName: "Dernier",
    rules: "Le joueur emportant le dernier pli marque %d points.",
    scoreRoute: Routes.barbuOrNoLastTrickScores,
    settingsRoute: Routes.barbuOrNoLastTrickSettings,
  ),
  @HiveField(5)
  trumps(
    displayName: "Salade",
    rules:
        "Ce contrat est une combinaison des contrats %s.\nC'est le contrat qui peut faire marquer le plus de points puisque les points de chaque contrat s'additionnent.",
    scoreRoute: Routes.trumpsScores,
    settingsRoute: Routes.trumpsSettings,
  ),
  @HiveField(6)
  domino(
    displayName: "Réussite",
    rules:
        "Le joueur choisissant ce contrat détermine la valeur d'ouverture de la réussite (par exemple le valet). S'il possède une carte de cette valeur, il la pose sur la table, sinon il passe son tour.\nLe joueur suivant peut ensuite poser une carte de même couleur et de valeur directement supérieure ou inférieure (donc le 10 ou la dame de la couleur précédente). Il peut aussi poser une carte de la valeur d'ouverture, dans une autre couleur. S'il ne peut pas poser de carte il indique qu'il passe.\nLe jeu se poursuit ainsi jusqu'à ce que tous les joueurs aient fini leur paquet. Les joueurs marquent un nombre de points dépendant de leur ordre de fin.",
    scoreRoute: Routes.dominoScores,
    settingsRoute: Routes.dominoSettings,
  );

  const ContractsInfo(
      {required this.displayName,
      required this.rules,
      required this.scoreRoute,
      required this.settingsRoute});

  final String displayName;
  final String rules;
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
