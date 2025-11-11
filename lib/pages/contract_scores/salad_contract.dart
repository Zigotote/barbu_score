import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/providers/contracts_manager.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/my_list_layouts.dart';
import '../../commons/widgets/my_subtitle.dart';
import '../../main.dart';
import 'notifiers/salad_provider.dart';
import 'widgets/rules_button.dart';

class SaladContractPage extends ConsumerWidget {
  const SaladContractPage({super.key});

  Widget _buildFields(
    BuildContext context,
    SaladNotifier provider,
    ContractsManager contractsManager,
  ) {
    return MyGrid(
      children: provider.subContracts.map((contract) {
        final contractValues = provider.getFilledContract(contract.name);
        final scoresRoute = contractsManager.getScoresRoute(contract);
        return ElevatedButtonWithIndicator(
          key: Key(contract.name),
          text: context.l10n.contractName(contract),
          onPressed: () => context.push(scoresRoute, extra: contractValues),
          indicator: contractValues != null
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Icon(
                    Icons.task_alt_outlined,
                    color: Theme.of(context).colorScheme.success,
                    size: 40,
                  ),
                )
              : null,
        );
      }).toList(),
    );
  }

  /// Saves the contract and moves to the next player round
  void _saveContract(
    BuildContext context,
    WidgetRef ref,
    SaladNotifier saladProvider,
  ) {
    ref
        .read(logProvider)
        .info("SaladContractPage.saveContract: save ${saladProvider.model}");
    final provider = ref.read(playGameProvider);
    provider.finishContract(saladProvider.model);

    context.go(
      provider.nextPlayer() ? Routes.chooseContract : Routes.finishGame,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(saladProvider);
    return MyDefaultPage(
      appBar: MyPlayerAppBar(
        player: ref.watch(playGameProvider).currentPlayer,
        context: context,
        trailing: RulesButton(ContractsInfo.salad),
      ),
      content: Column(
        spacing: 8,
        children: [
          MySubtitle(context.l10n.saladScoresSubtitle),
          _buildFields(context, provider, ref.read(contractsManagerProvider)),
        ],
      ),
      bottomWidget: ElevatedButtonFullWidth(
        onPressed: provider.isValid
            ? () => _saveContract(context, ref, provider)
            : null,
        child: Text(context.l10n.validateScores, textAlign: TextAlign.center),
      ),
    );
  }
}
