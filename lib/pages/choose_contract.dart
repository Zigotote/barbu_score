import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/my_grid.dart';
import '../widgets/my_page.dart';

/// A page for a player to choose his contract
class ChooseContract extends GetView<PartyController> {
  /// Builds a button for a contract the player can choose
  ElevatedButton _buildAvailableButton(ContractsNames contract) {
    return ElevatedButton(
      child: Text(contract.displayName()),
      onPressed: () => Get.toNamed(
        Routes.CONTRACT_SCORES,
        arguments: contract,
      ),
    );
  }

  /// Builds a button for a contract which has already been played
  ElevatedButtonCustomColor _buildUnavailableButton(ContractsNames contract) {
    return ElevatedButtonCustomColor(
      text: contract.displayName(),
      color: Get.theme.disabledColor,
      onPressed: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    PlayerController player = controller.currentPlayer;
    return MyPage(
      title: "Tour de ${player.name}",
      hasBackground: true,
      content: MyGrid(
        itemCount: ContractsNames.values.length,
        itemBuilder: (_, index) {
          ContractsNames contract = ContractsNames.values[index];
          return player.hasPlayedContract(contract)
              ? _buildUnavailableButton(contract)
              : _buildAvailableButton(contract);
        },
      ),
      buttomNavigationButton: ElevatedButtonFullWidth(
        text: "Scores",
        onPressed: null,
      ),
    );
  }
}
