import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/player.dart';
import '../models/contract_models.dart';
import '../models/contract_names.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a contract where each player has a different score
class IndividualScoresContract extends GetView<IndividualScoresController> {
  /// The contract the player choose
  final ContractsNames _contract = Get.arguments;

  IndividualScoresContract() {
    controller.maximalScore =
        (_contract.contract as AbstractMultipleLooserContractModel)
            .expectedItems;
  }

  Widget _buildFields() {
    return MyList(
      itemCount: controller.playerScores.length,
      itemBuilder: (_, index) {
        PlayerController player = controller.playerScores.keys.elementAt(index);
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButtonCustomColor(
                icon: Icons.remove,
                color: player.color,
                onPressed: () => controller.decreaseScore(player),
              ),
              Column(
                children: [
                  Text(player.name),
                  Obx(() => Text(controller.playerScores[player].toString()))
                ],
              ),
              ElevatedButtonCustomColor(
                icon: Icons.add,
                color: player.color,
                onPressed: () => controller.increaseScore(player),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage<IndividualScoresController>(
      subtitle:
          "Nombre de ${_contract.displayName.replaceFirst("Sans ", "")} par joueur",
      contract: _contract,
      child: _buildFields(),
    );
  }
}
