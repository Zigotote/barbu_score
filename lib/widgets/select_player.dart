import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import 'my_grid.dart';

/// A selector for the player who loose the contract
class SelectPlayer extends GetWidget<PartyController> {
  Widget build(BuildContext context) {
    return MyGrid(
      itemCount: controller.nbPlayers,
      itemBuilder: (_, index) => ElevatedButton(
        onPressed: null,
        child: Text(controller.players[index].name),
      ),
    );
  }
}
