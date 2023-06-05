import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/player.dart';
import '../models/contract_info.dart';
import '../widgets/colored_container.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a domino contract
class DominoScores extends GetView<OrderPlayersController> {
  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields() {
    return ReorderableListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      itemCount: controller.orderedPlayers.length,
      itemBuilder: (_, index) {
        PlayerController player = controller.orderedPlayers[index];
        return ReorderableDragStartListener(
          key: ValueKey(index),
          index: index,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  (index + 1).toString(),
                  style: Get.textTheme.headlineSmall,
                ),
                ColoredContainer(
                  height: Get.height * 0.08,
                  width: Get.width * 0.75,
                  color: player.color,
                  child: _buildPlayerTile(player),
                ),
              ],
            ),
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        controller.movePlayer(oldIndex, newIndex);
      },
    );
  }

  /// Builds a stack with the name of a player and a drag icon as a leading
  Widget _buildPlayerTile(PlayerController player) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            player.name,
            style: TextStyle(
              fontSize: 16,
              color: player.color,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Icon(
            Icons.drag_handle,
            color: player.color,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage<OrderPlayersController>(
      subtitle: "Quel est l'ordre des joueurs ?",
      contract: ContractsInfo.Domino,
      child: Expanded(child: _buildFields()),
    );
  }
}
