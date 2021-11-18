import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';
import '../models/contract_names.dart';
import '../models/route_argument.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';

/// A page for a player to choose his contract
class ChooseContract extends GetView<PartyController> {
  /// Builds a button for a contract the player can choose
  ElevatedButton _buildAvailableButton(ContractsNames contract) {
    return ElevatedButton(
      child: Text(contract.displayName),
      onPressed: () => Get.toNamed(
        contract.route,
        arguments: RouteArgument(
          contractName: contract,
          contractValues: null,
        ),
      ),
    );
  }

  /// Builds a button for a contract which has already been played
  Widget _buildUnavailableButton(ContractsNames contract) {
    return ElevatedButton(
      child: Text(contract.displayName),
      onPressed: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    PlayerController player = controller.currentPlayer;
    return DefaultPage(
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
      bottomWidget: ElevatedButton(
        child: Text("Scores"),
        onPressed: () => Get.toNamed(Routes.SCORES),
      ),
    );
  }
}
