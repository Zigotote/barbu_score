import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/widgets/alert_dialog.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/list_layouts.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/my_switch.dart';
import 'widgets/setting_question.dart';

/// A page to edit salad contract settings
class SaladContractSettingsPage extends ConsumerStatefulWidget {
  const SaladContractSettingsPage({super.key});

  @override
  ConsumerState<SaladContractSettingsPage> createState() =>
      _SaladContractSettingsPageState();
}

class _SaladContractSettingsPageState
    extends ConsumerState<SaladContractSettingsPage> {
  @override
  void initState() {
    super.initState();
    final playersWithContract = ref
        .read(contractSettingsProvider(ContractsInfo.salad))
        .playersWithContract;
    if (playersWithContract.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => MyAlertDialog(
            context: context,
            title: context.l10n.alertContractPlayed,
            content: context.l10n.alertSaladContractPlayedBy(
              playersWithContract.join(", "),
            ),
            actions: [AlertDialogActionButton(text: "OK")],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(contractSettingsProvider(ContractsInfo.salad));
    final settings = provider.settings as SaladContractSettings;
    return ContractSettingsPage(
      contract: ContractsInfo.salad,
      children: [
        Text(
          context.l10n.contractsToPlay,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        MyGrid(
          isScrollable: false,
          children: SaladContractSettings.availableContracts.map((contract) {
            final isActive = settings.contracts[contract.name]!;
            return ElevatedButtonWithIndicator(
              key: Key(contract.name),
              text: context.l10n.contractName(contract),
              onPressed: () => provider.modifySetting(
                (_) {
                  settings.contracts.update(contract.name, (_) => !isActive);
                  // Deactivate salad contract if no active contract inside it
                  if (!settings.contracts.containsValue(true)) {
                    settings.isActive = false;
                  }
                },
              )(null),
              indicator: Icon(
                isActive ? Icons.task_alt_outlined : Icons.cancel_outlined,
                color: isActive
                    ? Theme.of(context).colorScheme.success
                    : Theme.of(context).colorScheme.error,
                size: 40,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        SettingQuestion(
          tooltip: context.l10n.invertScoreDetails,
          label: context.l10n.invertScore,
          input: MySwitch(
            isActive: settings.invertScore,
            onChanged: provider.modifySetting(
              (bool value) => settings.invertScore = value,
            ),
          ),
        ),
      ],
    );
  }
}
