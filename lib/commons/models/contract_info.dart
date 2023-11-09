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
        "Ce contrat est une combinaison de tous les contrats précédents. Il ne faut donc pas remporter de %s. C'est le contrat qui peut faire marquer le plus de points puisque les points de chaque contrat s'additionnent.",
    scoreRoute: Routes.trumpsScores,
    settingsRoute: Routes.trumpsSettings,
  ),
  @HiveField(6)
  domino(
    displayName: "Réussite",
    rules:
        "Le joueur choisissant ce contrat détermine la valeur d'ouverture de la réussite. S'il possède une carte de cette valeur, il la pose sur la table, sinon il passe son tour. Le joueur suivant peut ensuite poser une carte de même couleur et de valeur directement supérieure ou inférieure à cette première carte. Il peut aussi poser une carte de la valeur d'ouverture. S'il ne peut pas poser de carte il indique qu'il passe. Le jeu se poursuite ainsi jusqu'à ce que tous les joueurs aient fini leur paquet. Les joueurs marquent un nombre de points dépendant de leur ordre de fin.",
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
        return IndividualScoresContractSettings(points: 5);
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
        return DominoContractSettings(
          pointsFirstPlayer: -40,
          pointsLastPlayer: 40,
        );
    }
  }
}
