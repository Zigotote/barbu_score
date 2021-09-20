import 'package:barbu_score/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import 'my_grid.dart';

/// A selector for the player who loose the contract
class SelectPlayer extends GetWidget<PartyController> {
  @override
  Widget build(BuildContext context) {
    return MyGrid(
      itemCount: controller.nbPlayers,
      itemBuilder: (_, index) => ElevatedButtonCustomColor(
        text: controller.players[index].name,
        color: controller.players[index].color,
        onPressed: null,
      ),
    );
  }
}
