import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/party.dart';
import '../controller/player.dart';
import '../main.dart';

/// A page for a player to choose his contract
class ChooseContract extends GetView<PartyController> {
  /// Builds the list of contracts to display
  List<Widget> _buildContractsList(String title, List<ContractsNames> list) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(title),
      ),
      Wrap(
        alignment: WrapAlignment.center,
        children: list.map(
          (contract) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: OutlinedButton(
                onPressed: () => Get.toNamed(
                  Routes.CONTRACT_SCORES,
                  arguments: contract,
                ),
                child: Text(contract.displayName()),
              ),
            );
          },
        ).toList(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    PlayerController player = controller.currentPlayer;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tour de ${player.name}"),
      ),
      body: Column(children: [
        ..._buildContractsList(
            "Contrats disponibles :", player.availableContracts),
        ..._buildContractsList("Contrats déjà pris :", player.choosenContracts),
      ]),
    );
  }
}
