import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../commons/utils/storage.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/ordered_players_scores.dart';
import '../main.dart';

/// A page to display the scores of each player at the end of the game
class FinishGame extends StatelessWidget {
  const FinishGame({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Fin de partie",
      content: const OrderedPlayersScores(),
      bottomWidget: ElevatedButton(
        child: const Text("Retour à l'accueil"),
        onPressed: () {
          MyStorage().delete();
          context.go(Routes.home);
        },
      ),
    );
  }
}
