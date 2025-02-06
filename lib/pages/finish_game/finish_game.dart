import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/providers/log.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/ordered_players_scores.dart';
import '../../main.dart';
import 'widgets/game_table.dart';

/// A page to display the scores of each player at the end of the game
class FinishGame extends ConsumerWidget {
  const FinishGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(logProvider).info("FinishGame: finished game");
    ref.read(logProvider).sendAnalyticEvent("finish_game");
    return DefaultPage(
      appBar: MyAppBar(
        "Fin de partie",
        context: context,
        tabs: const [Tab(text: "Classement"), Tab(text: "Scores par contrat")],
      ),
      content: const TabBarView(
        children: [OrderedPlayersScores(isGameFinished: true), GameTable()],
      ),
      bottomWidget: ElevatedButton(
        child: const Text("Retour à l'accueil"),
        onPressed: () => Navigator.of(context).popAndPushNamed(Routes.home),
      ),
    );
  }
}
