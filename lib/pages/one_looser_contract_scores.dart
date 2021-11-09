import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/contract_names.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../controller/contract.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/my_grid.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a contract where only one player can loose
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
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: Get.width * 0.42,
                  height: Get.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(
                      color: Get.theme.colorScheme.onSurface,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
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
    party.finishContract(contract, {playerWithScore: 1});
    Get.delete<SelectPlayerController>();
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      subtitle: "Qui a remporté le ${contract.displayName} ?",
      child: _buildFields(),
      contractController: controller,
      onNextPlayer: _saveScore,
    );
  }
}
