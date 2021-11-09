import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../models/contract_models.dart';
import '../models/contract_names.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a contract where each player has a different score
class IndividualScoresContract extends GetView<IndividualScoresController> {
  /// The current party
  final PartyController party = Get.find<PartyController>();

  /// The contract the player choose
  final ContractsNames contract = Get.arguments;

  IndividualScoresContract() {
    controller.maximalScore =
        (contract.contract as AbstractMultipleLooserContractModel)
            .expectedItems;
  }

  Widget _buildFields() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.04,
        horizontal: Get.width * 0.02,
      ),
      shrinkWrap: true,
      itemCount: controller.playerScores.length,
      itemBuilder: (_, index) {
        PlayerController player =
            controller.playerScores.entries.toList()[index].key;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButtonCustomColor(
                text: "-",
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
                text: "+",
                color: player.color,
                onPressed: () => controller.increaseScore(player),
              )
            ],
          ),
        );
      },
    );
  }

  /// Saves the score for this contract
  void _saveScore() {
    party.finishContract(contract, controller.playerScores);
    Get.delete<IndividualScoresController>();
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      subtitle:
          "Nombre de ${contract.displayName.replaceFirst("Sans ", "")} par joueur",
      child: _buildFields(),
      contractController: controller,
      onNextPlayer: _saveScore,
    );
  }
}
