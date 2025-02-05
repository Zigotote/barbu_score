import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/providers/log.dart';
import '../commons/providers/play_game.dart';
import '../commons/providers/storage.dart';
import '../commons/utils/snackbar.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/my_appbar.dart';
import '../commons/widgets/ordered_players_scores.dart';
import '../main.dart';

/// A page to display the scores of each player for the game
class MyScores extends ConsumerWidget {
  const MyScores({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultPage(
      appBar: MyAppBar("Scores", context: context, hasLeading: true),
      content: const OrderedPlayersScores(),
      bottomWidget: ElevatedButton(
          child: const Text('Sauvegarder et quitter'),
          onPressed: () {
            final game = ref.read(playGameProvider).game;
            ref.read(logProvider).info("MyScores: save $game");
            ref.read(logProvider).sendAnalyticEvent(
              "Save game",
              parameters: {"nbPlayers": game.players.length},
            );
            ref.read(storageProvider).saveGame(game);
            Navigator.of(context).popAndPushNamed(Routes.home);
            SnackBarUtils.instance.openSnackBar(
              context: context,
              title: "Partie sauvegardée",
              text: "Sélectionnez \"Charger une partie\" pour la poursuivre.",
            );
          }),
    );
  }
}
