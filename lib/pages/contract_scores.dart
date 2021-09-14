import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../main.dart';

/// A page to fill the scores for a contract
class ContractScores extends GetView<PartyController> {
  /// The contract the player choose
  final ContractsNames contract = Get.arguments;

  List<Widget> _buildFields() {
    return controller.players.map((player) {
      if (contract == ContractsNames.Barbu ||
          contract == ContractsNames.NoLastTrick) {
        return Row(
          children: [
            Text(player.name),
            Checkbox(value: false, onChanged: (value) => null)
          ],
        );
      } else {
        int score = 0;
        return Row(
          children: [
            Text(player.name),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => score--,
            ),
            Text(score.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => score++,
            ),
          ],
        );
      }
    }).toList();
  }

  /// Navigates to the next player or ends the party if no round left
  void _nextPlayer() {
    controller.currentPlayer
        .addContract(contract, {controller.currentPlayer: 0});
    if (controller.nextPlayer()) {
      Get.toNamed(Routes.CHOOSE_CONTRACT);
    } else {
      Get.toNamed(Routes.HOME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tour de ${controller.currentPlayer.name}"),
      ),
      body: Column(
        children: [
          Center(child: Text(contract.displayName())),
          ..._buildFields(),
          OutlinedButton(
            onPressed: () => _nextPlayer(),
            child: Text("Joueur suivant"),
          )
        ],
      ),
    );
  }
}
