import 'package:barbu_score/main.dart';
import 'package:barbu_score/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';
import '../widgets/player_score_button.dart';

/// A page to display the scores of each player for the party
class MyScores extends GetView<PartyController> {
  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      hasLeading: true,
      title: "Scores",
      content: MyList(
        itemCount: controller.nbPlayers + 1,
        itemBuilder: (_, index) {
          if (index < controller.players.length) {
            PlayerController player = controller.players[index];
            return PlayerScoreButton(
              player: player,
              score: controller.playerScores[player]!,
            );
          } else {
            return ElevatedButton(
              onPressed: () {
                MyStorage().onInactive();
                Get.toNamed(Routes.HOME);
              },
              child: Text("tmp button go home"),
            );
          }
        },
      ),
    );
  }
}
