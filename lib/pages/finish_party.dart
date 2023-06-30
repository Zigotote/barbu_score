import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../commons/utils/storage.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/list_layouts.dart';
import '../commons/widgets/player_score_button.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';

/// A page to display the scores of each player at the end of the party
class FinishParty extends GetView<PartyController> {
  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Fin de partie",
      content: MyList(
        itemCount: controller.nbPlayers,
        itemBuilder: (_, index) {
          PlayerController player = controller.orderedPlayers[index];
          return PlayerScoreButton(
            player: player,
            score: controller.playerScores[player.name]!,
            isFirst: index == 0,
            bestFriend: controller.bestFriend(player),
            worstEnnemy: controller.worstEnnemy(player),
          );
        },
      ),
      bottomWidget: ElevatedButton(
        child: Text("Retour à l'accueil"),
        onPressed: () {
          MyStorage().delete();
          Get.toNamed(Routes.HOME);
          Get.deleteAll();
        },
      ),
    );
  }
}
