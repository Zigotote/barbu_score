import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/select_player.dart';
import '../widgets/custom_buttons.dart';
import 'my_grid.dart';

/// A selector for the player who loose the contract
class SelectPlayer extends GetWidget<PartyController> {
  /// The contract the player choose
  final SelectPlayerController _selectPlayerController =
      Get.find<SelectPlayerController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyGrid(
          itemCount: controller.nbPlayers,
          itemBuilder: (_, index) => ElevatedButtonCustomColor(
              text: controller.players[index].name,
              color: controller.players[index].color,
              onPressed: () =>
                  _selectPlayerController.selectedPlayerIndex = index),
        ),
        Obx(
          () => Visibility(
            visible: _selectPlayerController.showSelectionBox,
            child: AnimatedPositioned(
              top: _selectPlayerController.topPositionSelectionBox,
              left: _selectPlayerController.leftPositionSelectionBox,
              child: Container(
                width: Get.width * 0.42,
                height: Get.height * 0.15,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Get.theme.colorScheme.onSurface,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              duration: Duration(milliseconds: 600),
            ),
          ),
        )
      ],
    );
  }
}
