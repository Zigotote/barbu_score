import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_models.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/list_layouts.dart';
import '../../commons/widgets/my_subtitle.dart';
import '../../main.dart';
import 'models/contract_route_argument.dart';
import 'notifiers/trumps_provider.dart';

class TrumpsContractPage extends ConsumerWidget {
  const TrumpsContractPage({super.key});

  Widget _buildFields(BuildContext context, TrumpsNotifier provider) {
    return MyGrid(
      children: provider.subContracts.map((contract) {
        final contractValues = provider.getFilledContract(contract.name);
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
      AbstractSubContractModel contractValues) {
    return ElevatedButtonWithIndicator(
      text: contract.displayName,
      onPressed: () => Navigator.of(context).pushNamed(
        contract.scoreRoute,
        arguments: ContractRouteArgument(
          contractInfo: contract,
          contractModel: contractValues,
        ),
      ),
      indicator: Icon(
        Icons.task_alt_outlined,
        color: Theme.of(context).colorScheme.success,
      ),
    );
  }

  /// Saves the contract and moves to the next player round
  void _saveContract(
      BuildContext context, WidgetRef ref, TrumpsNotifier trumpsProvider) {
    ref
        .read(logProvider)
        .info("TrumpsContractPage.saveContract: save $trumpsProvider");
    final provider = ref.read(playGameProvider);
    provider.finishContract(trumpsProvider.model);

    Navigator.of(context).popAndPushNamed(
      provider.nextPlayer() ? Routes.chooseContract : Routes.finishGame,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(trumpsProvider);
    return DefaultPage(
      title: "Tour de ${ref.watch(playGameProvider).currentPlayer.name}",
      hasLeading: true,
      content: Column(
        children: [
          const MySubtitle("Quel est le score de chaque contrat ?"),
          const SizedBox(height: 8),
          Expanded(child: _buildFields(context, provider)),
        ],
      ),
      bottomWidget: ElevatedButton(
        onPressed: provider.isValid
            ? () => _saveContract(context, ref, provider)
            : null,
        child: const Text("Valider les scores"),
      ),
    );
  }
}
