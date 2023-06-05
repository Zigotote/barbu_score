import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/contract.dart';
import '../models/contract_info.dart';
import '../models/route_argument.dart';
import '../theme/my_themes.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/list_layouts.dart';
import '../widgets/page_layouts.dart';

/// A page to fill the scores for a trump contract
class TrumpsScores extends GetView<TrumpsScoresController> {
  Widget _buildFields(BuildContext context) {
    return MyGrid(
      children: controller.trumpContracts
          .map((contract) => controller.isFilled(contract.name)
              ? _buildFilledContract(context, contract)
              : _buildContractButton(contract))
          .toList(),
    );
  }

  /// Builds a button to fill a contract
  ElevatedButton _buildContractButton(ContractsInfo contract) {
    return ElevatedButton(
      child: Text(contract.displayName, textAlign: TextAlign.center),
      onPressed: () => Get.toNamed(
        contract.route,
        arguments: RouteArgument(
          contractInfo: contract,
          contractValues: controller.getFilledContract(contract.name),
        ),
      ),
    );
  }

  /// Builds a Widget for a filled contract, with the button and a tick to know that it has been filled
  Widget _buildFilledContract(BuildContext context, ContractsInfo contract) {
    return ElevatedButtonTopRightWidget(
      text: contract.displayName,
      topRightChild: Icon(
        Icons.task_alt_outlined,
        color: Theme.of(context).colorScheme.successColor,
      ),
      onPressed: () => Get.toNamed(
        contract.route,
        arguments: RouteArgument(
          contractInfo: contract,
          contractValues: controller.getFilledContract(contract.name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage<TrumpsScoresController>(
      subtitle: "Quel est le score de chaque contrat ?",
      contract: ContractsInfo.Trumps,
      child: Expanded(child: _buildFields(context)),
    );
  }
}
