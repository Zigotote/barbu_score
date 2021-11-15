import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';
import '../widgets/player_icon.dart';

class MyScores extends GetView<PartyController> {
  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Scores",
      content: MyList(
        itemCount: controller.nbPlayers,
        itemBuilder: (_, index) {
          PlayerController player = controller.players[index];
          return ElevatedButtonFullWidth(
            child: Row(
              children: [
                PlayerIcon(
                  image: player.image,
                  color: player.color,
                  size: Get.width * 0.15,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(player.name),
                      Text("${controller.playerScores[player]} points"),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
            onPressed: null,
          );
        },
      ),
    );
  }
}
