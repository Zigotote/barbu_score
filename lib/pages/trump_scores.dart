import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../models/contract_names.dart';
import '../models/route_argument.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a domino contract
class TrumpsScores extends GetView<TrumpsScoresController> {
  Widget _buildFields() {
    return MyGrid(
      itemCount: controller.trumpContracts.length,
      itemBuilder: (_, index) {
        ContractsNames contract = controller.trumpContracts[index];
        return controller.isFilled(contract)
            ? _buildFilledContract(contract)
            : _buildContractButton(contract);
      },
    );
  }

  /// Builds a button to fill a contract
  ElevatedButton _buildContractButton(ContractsNames contract) {
    return ElevatedButton(
      child: Text(contract.displayName),
      onPressed: () {
        return Get.toNamed(
          contract.route,
          arguments: RouteArgument(
            contractName: contract,
            contractValues: controller.getFilledContract(contract),
          ),
        );
      },
    );
  }

  /// Builds a Widget for a filled contract, with the button and a tick to know that it has been filled
  Stack _buildFilledContract(ContractsNames contract) {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        _buildContractButton(contract),
        Positioned(
          right: 8,
          top: 8,
          child: Icon(
            Icons.task_alt_outlined,
            color: Get.theme.highlightColor,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage<TrumpsScoresController>(
      subtitle: "Quel est le score de chaque contrat ?",
      contract: ContractsNames.Trumps,
      child: Expanded(child: _buildFields()),
    );
  }
}