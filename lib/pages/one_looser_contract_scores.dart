import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/contract_names.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../controller/contract.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/my_grid.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a barbu or no last trick contract
class OneLooserContractScores extends GetView<SelectPlayerController> {
  /// The current party
  final PartyController party = Get.find<PartyController>();

  /// The contract the player choose
  final ContractsNames contract = Get.arguments;

  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields() {
    return Stack(
      children: [
        MyGrid(
          itemCount: party.nbPlayers,
          itemBuilder: (_, index) => ElevatedButtonCustomColor(
            text: party.players[index].name,
            color: party.players[index].color,
            onPressed: () => controller.selectedPlayerIndex = index,
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.isValid,
            child: AnimatedPositioned(
              top: controller.topPositionSelectionBox,
              left: controller.leftPositionSelectionBox,
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
              duration: Duration(milliseconds: 400),
            ),
          ),
        )
      ],
    );
  }

  /// Saves the score for this contract
  void _saveScore() {
    PlayerController playerWithScore =
        party.players[controller.selectedPlayerIndex];
    party.currentPlayer.addContract(contract, {playerWithScore: 1});
    Get.delete<SelectPlayerController>();
    party.nextPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      contractName: contract.displayName,
      child: _buildFields(),
      contractController: controller,
      onNextPlayer: _saveScore,
    );
  }
}
