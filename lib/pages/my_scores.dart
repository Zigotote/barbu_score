import 'package:barbu_score/commons/widgets/ordered_players_scores.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../commons/utils/snackbar.dart';
import '../commons/widgets/default_page.dart';
import '../main.dart';

/// A page to display the scores of each player for the party
class MyScores extends StatelessWidget {
  const MyScores({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      hasLeading: true,
      title: "Scores",
      content: const OrderedPlayersScores(),
      bottomWidget: ElevatedButton(
          child: const Text('Sauvegarder et quitter'),
          onPressed: () {
            //MyStorage().saveParty();
            context.go(Routes.home);
            SnackbarUtils.instance.openSnackBar(
              context: context,
              title: "Partie sauvegardée",
              text: "Sélectionnez 'Charger une partie' pour la poursuivre.",
            );
          }),
    );
  }
}
