import 'package:barbu_score/pages/rules/widgets/rules_page.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../commons/models/player_colors.dart';

class GameRoundRules extends ConsumerWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const GameRoundRules(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesByStep = [
      "Distribuer les cartes entre les joueurs : chacun doit en avoir 8.",
      "Le premier joueur choisit le contrat qu'il souhaite jouer et l'annonce aux autres joueurs.",
      "Il pose la première carte du pli. Cette carte détermine la couleur du pli.",
      "Les joueurs jouent ensuite dans le sens des aiguilles d'une montre.",
      "Si un joueur ne possède pas de carte de la couleur demandée, il peut poser n'importe quelle carte de son paquet. La valeur de cette carte sera alors considérée comme nulle.",
      "A la fin du tour, le joueur ayant posé la carte de la plus grande valeur emporte le pli. C'est lui qui démarrera le pli suivant.",
      "La manche s'arrête lorsque les joueurs ont joué toutes leurs cartes.",
      "Les points sont ensuite comptés selon le contrat choisi par le premier joueur",
      "La nouvelle manche est démarrée par le joueur à la gauche du premier joueur précédent.",
    ];
    return RulesPage(
      pageIndex: pageIndex,
      title: "Déroulement d'une manche",
      content: Column(
        children: [
          const SizedBox(height: 8),
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
