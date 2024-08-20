import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/notifiers/play_game.dart';
import '../commons/notifiers/storage.dart';
import '../commons/utils/snackbar.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/ordered_players_scores.dart';
import '../main.dart';

/// A page to display the scores of each player for the game
class MyScores extends ConsumerWidget {
  const MyScores({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultPage(
      hasLeading: true,
      title: "Scores",
      content: const OrderedPlayersScores(),
      bottomWidget: ElevatedButton(
          child: const Text('Sauvegarder et quitter'),
          onPressed: () {
            ref.read(storageProvider).saveGame(ref.read(playGameProvider).game);
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
