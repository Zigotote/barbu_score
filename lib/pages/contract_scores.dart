import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../main.dart';

/// A page to fill the scores for a contract
class ContractScores extends GetView<PartyController> {
  /// The contract the player choose
  final ContractsNames contract = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tour de ${controller.currentPlayer.name}"),
      ),
      body: Column(
        children: [
          Center(child: Text(contract.displayName())),
          OutlinedButton(
            onPressed: () {
              controller.currentPlayer
                  .addContract(contract, {controller.currentPlayer: 0});
              if (controller.nextPlayer()) {
                Get.toNamed(Routes.CHOOSE_CONTRACT);
              } else {
                Get.toNamed(Routes.HOME);
              }
            },
            child: Text("Joueur suivant"),
          )
        ],
      ),
    );
  }
}
