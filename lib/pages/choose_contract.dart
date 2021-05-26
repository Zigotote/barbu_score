import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../controller/player.dart';

/// A page for a player to choose his contract
class ChooseContract extends StatelessWidget {
  /// The player who needs to choose a contract
  final PlayerController player = Get.arguments;

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
                onPressed: () => null,
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
