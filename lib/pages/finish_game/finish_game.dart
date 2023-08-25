import 'package:flutter/material.dart';

import '../../commons/utils/storage.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/ordered_players_scores.dart';
import '../../main.dart';
import 'widgets/game_table.dart';

/// A page to display the scores of each player at the end of the game
class FinishGame extends StatelessWidget {
  const FinishGame({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Fin de partie",
      tabs: const [Tab(text: "Classement"), Tab(text: "Scores par contrat")],
      content: const TabBarView(
        children: [OrderedPlayersScores(isFinished: true), GameTable()],
      ),
      bottomWidget: ElevatedButton(
        child: const Text("Retour à l'accueil"),
        onPressed: () {
          MyStorage().deleteGame();
          Navigator.of(context).popAndPushNamed(Routes.home);
        },
      ),
    );
  }
}
