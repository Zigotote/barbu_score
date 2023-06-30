import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../commons/utils/snackbar.dart';
import '../commons/utils/storage.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/list_layouts.dart';
import '../commons/widgets/player_score_button.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';

/// A page to display the scores of each player for the party
class MyScores extends GetView<PartyController> {
  const MyScores({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      hasLeading: true,
      title: "Scores",
      content: MyList(
        itemCount: controller.nbPlayers,
        itemBuilder: (_, index) {
          PlayerController player = controller.orderedPlayers[index];
          return PlayerScoreButton(
            player: player,
            score: controller.playerScores[player.name]!,
          );
        },
      ),
      bottomWidget: ElevatedButton(
          child: const Text('Sauvegarder et quitter'),
          onPressed: () {
            MyStorage().saveParty();
            Get.toNamed(Routes.home);
            SnackbarUtils.instance.openSnackBar(
              context: context,
              title: "Partie sauvegardée",
              text: "Sélectionnez 'Charger une partie' pour la poursuivre.",
            );
          }),
    );
  }
}
