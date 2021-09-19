import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';
import '../widgets/button_full_width.dart';
import '../widgets/my_appbar.dart';

/// A page for a player to choose his contract
class ChooseContract extends GetView<PartyController> {
  /// Builds a button for a contract the player can choose
  ElevatedButton _buildAvailableButton(ContractsNames contract) {
    return ElevatedButton(
      onPressed: () => Get.toNamed(
        Routes.CONTRACT_SCORES,
        arguments: contract,
      ),
      child: Text(contract.displayName()),
    );
  }

  /// Builds a button for a contract which has already been played
  ElevatedButton _buildUnavailableButton(ContractsNames contract) {
    Color buttonColor = Colors.grey;
    return ElevatedButton(
      onPressed: null,
      child: Text(
        contract.displayName(),
        style: TextStyle(color: buttonColor),
      ),
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: buttonColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PlayerController player = controller.currentPlayer;
    return Scaffold(
      appBar: MyAppBar("Tour de ${player.name}"),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.015,
        ),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Get.width * 0.1,
              mainAxisSpacing: Get.width * 0.1,
              childAspectRatio: 2,
            ),
            itemCount: ContractsNames.values.length,
            itemBuilder: (_, index) {
              ContractsNames contract = ContractsNames.values[index];
              return player.hasPlayedContract(contract)
                  ? _buildUnavailableButton(contract)
                  : _buildAvailableButton(contract);
            }),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(Get.width * 0.05),
        child: ElevatedButtonFullWidth(
          onPressed: null,
          text: "Scores",
        ),
      ),
    );
  }
}
