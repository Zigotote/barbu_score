import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../models/contract_names.dart';
import '../widgets/colored_container.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a domino contract
class DominoScores extends GetView<OrderPlayersController> {
  /// The current party
  final PartyController party = Get.find<PartyController>();

  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields() {
    return ReorderableListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.orderedPlayers.length,
      itemBuilder: (_, index) {
        PlayerController player = controller.orderedPlayers[index];
        return Padding(
          key: ValueKey(index),
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (index + 1).toString(),
                style: Get.textTheme.headline5,
              ),
              ColoredContainer(
                height: Get.height * 0.08,
                width: Get.width * 0.75,
                color: player.color,
                child: _buildPlayerTile(player),
              ),
            ],
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        controller.movePlayer(oldIndex, newIndex);
      },
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.02,
      ),
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

  /// Saves the score for this contract
  void _saveScore() {
    party.currentPlayer.addContract(
      ContractsNames.Domino,
      Map.fromIterable(
        controller.orderedPlayers,
        key: (player) => player,
        value: (player) => controller.orderedPlayers.indexOf(player),
      ),
    );
    Get.delete<OrderPlayersController>();
    party.nextPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      contractName: ContractsNames.Domino.displayName,
      child: Expanded(child: _buildFields()),
      contractController: controller,
      onNextPlayer: _saveScore,
    );
  }
}
