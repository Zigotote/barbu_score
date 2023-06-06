import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../models/contract_names.dart';
import '../models/route_argument.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a contract where only one player can loose
class OneLooserContractScores extends GetView<SelectPlayerController> {
  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields(Color defaultTextColor) {
    final PartyController party = Get.find<PartyController>();
    return MyGrid(
      children: party.players
          .asMap()
          .entries
          .map(
            (entry) => Obx(
              () {
                Color playerColor = entry.value.color;
                bool isPlayerSelected =
                    controller.selectedPlayerIndex == entry.key;
                return ElevatedButtonCustomColor(
                  text: entry.value.name,
                  color: isPlayerSelected ? defaultTextColor : playerColor,
                  onPressed: () => controller.selectedPlayerIndex = entry.key,
                  backgroundColor: isPlayerSelected ? playerColor : null,
                );
              },
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ContractsNames contract =
        (Get.arguments as RouteArgument).contractName;
    return ContractPage<SelectPlayerController>(
      subtitle: "Qui a remporté le ${contract.displayName} ?",
      contract: contract,
      child: Expanded(
        child: _buildFields(Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }
}
