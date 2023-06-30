import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../commons/models/player.dart';
import '../commons/utils/storage.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/list_layouts.dart';
import '../commons/widgets/player_score_button.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';

/// A page to display the scores of each player at the end of the party
class FinishParty extends GetView<PartyController> {
  const FinishParty({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Fin de partie",
      content: MyList(
        itemCount: controller.nbPlayers,
        itemBuilder: (_, index) {
          PlayerController player = controller.orderedPlayers[index];
          return PlayerScoreButton(
            // TODO Océane tmp
            player: Player(color: Colors.black, image: ''),
            score: controller.playerScores[player.name]!,
            isFirst: index == 0,
            bestFriend: Player(color: Colors.black, image: ''),
            worstEnnemy: Player(color: Colors.black, image: ''),
          );
        },
      ),
      bottomWidget: ElevatedButton(
        child: const Text("Retour à l'accueil"),
        onPressed: () {
          MyStorage().delete();
          Get.toNamed(Routes.home);
          Get.deleteAll();
        },
      ),
    );
  }
}
