import 'package:barbu_score/commons/widgets/ordered_players_scores.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../commons/widgets/default_page.dart';
import '../main.dart';

/// A page to display the scores of each player at the end of the party
class FinishParty extends StatelessWidget {
  const FinishParty({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Fin de partie",
      content: const OrderedPlayersScores(),
      bottomWidget: ElevatedButton(
        child: const Text("Retour à l'accueil"),
        onPressed: () => context.go(Routes.home),
      ),
    );
  }
}
