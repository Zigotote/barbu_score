import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/contract.dart';
import '../controller/party.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a contract
class ContractScores extends GetView<PartyController> {
  /// The contract the player choose
  final ContractsNames contract = Get.arguments;

  /// Saves the score and navigates to the next player or ends the party if no round left
  void _nextPlayer() {
    controller.currentPlayer
        .addContract(contract, {controller.currentPlayer: 0});
    controller.nextPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      contractName: contract.displayName,
      child: Text("Not yet implemented"),
      onNextPlayer: () => _nextPlayer(),
    );
  }
}
