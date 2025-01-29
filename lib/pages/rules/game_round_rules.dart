import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../commons/models/player_colors.dart';
import 'widgets/rules_page.dart';

class GameRoundRules extends StatelessWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const GameRoundRules(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final rulesByStep = [
      "Distribuer les cartes entre les joueurs\u00a0: chacun doit en avoir 8.",
      "Le premier joueur choisit le contrat qu'il souhaite jouer et l'annonce aux autres joueurs.",
      "Il démarre le pli en posant une carte, qui détermine la couleur du pli",
      "Chaque joueur pose une carte dans le sens des aiguilles d'une montre.",
      "Si un joueur ne possède pas de carte de la couleur demandée, il peut poser n'importe quelle carte de son paquet. La valeur de cette carte sera alors considérée comme nulle.",
      "A la fin du tour, le joueur ayant posé la carte de la plus grande valeur emporte le pli. C'est lui qui démarrera le pli suivant.",
      "La manche s'arrête lorsque les joueurs ont joué toutes leurs cartes.",
      "Les points sont ensuite comptés selon le contrat choisi par le premier joueur",
      "Le joueur à la gauche du premier joueur précédent démarre la manche suivante.",
    ];
    return RulesPage(
      pageIndex: pageIndex,
      title: "Manche de jeu",
      content: Column(
        children: [
          const SizedBox(height: 16),
          FixedTimeline.tileBuilder(
            builder: TimelineTileBuilder.connected(
              nodePositionBuilder: (_, __) => 0,
              connectorBuilder: (_, __, ___) => Connector.solidLine(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              indicatorBuilder: (_, index) => Indicator.dot(
                size: 24,
                color: Theme.of(context).colorScheme.convertPlayerColor(
                      PlayerColors.values[index % PlayerColors.values.length],
                    ),
              ),
              itemCount: rulesByStep.length,
              contentsBuilder: (_, index) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 16),
                child: Text(rulesByStep[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
