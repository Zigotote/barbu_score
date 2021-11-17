import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../models/contract_names.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a contract where only one player can loose
class OneLooserContractScores extends GetView<SelectPlayerController> {
  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields() {
    final PartyController party = Get.find<PartyController>();
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
                  width: Get.width * 0.43,
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

  @override
  Widget build(BuildContext context) {
    final ContractsNames contract = Get.arguments;
    return ContractPage<SelectPlayerController>(
      subtitle: "Qui a remporté le ${contract.displayName} ?",
      contract: contract,
      child: _buildFields(),
    );
  }
}
