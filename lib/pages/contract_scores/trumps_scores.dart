import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_models.dart';
import '../../commons/widgets/list_layouts.dart';
import 'models/contract_route_argument.dart';
import 'notifiers/trumps_provider.dart';
import 'widgets/contract_page.dart';
import 'widgets/modify_contract_button.dart';

/// A page to fill the scores for a trumps contract
class TrumpsScores extends ConsumerWidget {
  const TrumpsScores({super.key});

  Widget _buildFields(BuildContext context, TrumpsNotifier provider) {
    return MyGrid(
      children: provider.trumpContracts.map((contract) {
        final AbstractContractModel? contractValues =
            provider.getFilledContract(contract.name);
        return contractValues == null
            ? _buildContractButton(context, contract)
            : _buildFilledContract(context, contract, contractValues);
      }).toList(),
    );
  }

  /// Builds a button to fill a contract
  ElevatedButton _buildContractButton(
      BuildContext context, ContractsInfo contract) {
    return ElevatedButton(
      child: Text(contract.displayName, textAlign: TextAlign.center),
      onPressed: () => Navigator.of(context).pushNamed(
        contract.scoreRoute,
        arguments: ContractRouteArgument(contractInfo: contract),
      ),
    );
  }

  /// Builds a Widget for a filled contract, with the button and a tick to know that it has been filled
  Widget _buildFilledContract(BuildContext context, ContractsInfo contract,
      AbstractContractModel contractValues) {
    return ModifyContractButton(
      text: contract.displayName,
      onPressed: () => Navigator.of(context).pushNamed(
        contract.scoreRoute,
        arguments: ContractRouteArgument(
          contractInfo: contract,
          contractValues: contractValues,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(trumpsProvider);
    return ContractPage(
      subtitle: "Quel est le score de chaque contrat ?",
      contract: ContractsInfo.trumps,
      isValid: provider.isValid,
      itemsByPlayer: provider.playerScores,
      child: _buildFields(context, provider),
    );
  }
}
