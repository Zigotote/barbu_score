import 'package:barbu_score/controller/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/select_player.dart';
import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/my_page.dart';
import '../widgets/select_player.dart';

/// A page to fill the scores for a contract
class ContractScores extends GetView<PartyController> {
  /// The contract the player choose
  final ContractsNames contract = Get.arguments;

  Widget _buildFields() {
    if (contract == ContractsNames.Barbu ||
        contract == ContractsNames.NoLastTrick) {
      Get.put(SelectPlayerController());
      return SelectPlayer();
    } else {
      return Text("Not yet implemented");
    }
  }

  /// Saves the score and navigates to the next player or ends the party if no round left
  void _nextPlayer() {
    if (contract == ContractsNames.Barbu ||
        contract == ContractsNames.NoLastTrick) {
      SelectPlayerController selectPlayerController =
          Get.find<SelectPlayerController>();
      PlayerController playerWithScore =
          controller.players[selectPlayerController.selectedPlayerIndex];
      controller.currentPlayer.addContract(
        contract,
        Map.fromIterable(
          controller.players,
          key: (player) => player,
          value: (player) {
            if (player == playerWithScore) {
              return contract.maximalScore();
            } else {
              return 0;
            }
          },
        ),
      );
      Get.delete<SelectPlayerController>();
    } else {
      print("Not yet implemented");
      controller.currentPlayer
          .addContract(contract, {controller.currentPlayer: 0});
    }
    if (controller.nextPlayer()) {
      Get.toNamed(Routes.CHOOSE_CONTRACT);
    } else {
      Get.toNamed(Routes.HOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyPage(
      title: "Tour de ${controller.currentPlayer.name}",
      content: Column(
        children: [
          Center(
            child: Text(
              contract.displayName(),
              style: Get.textTheme.subtitle2,
            ),
          ),
          _buildFields(),
        ],
      ),
      buttomNavigationButton: ElevatedButtonFullWidth(
        text: "Joueur suivant",
        onPressed: () => _nextPlayer(),
      ),
    );
  }
}
