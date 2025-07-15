import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/widgets/alert_dialog.dart';
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
        Semantics(
          header: true,
          child: Text(
            context.l10n.contractsToPlay,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        ...SaladContractSettings.availableContracts.map(
          (contract) => SettingQuestion(
            key: Key(contract.name),
            label: context.l10n.contractName(contract),
            onTap: () {
              final newContracts = Map<String, bool>.from(settings.contracts)
                ..update(contract.name, (value) => !value);
              provider.updateSettings(
                settings.copyWith(
                  isActive: !newContracts.containsValue(true) ? false : null,
                  contracts: newContracts,
                ),
              );
            },
            input: MySwitch(
              isActive: settings.contracts[contract.name]!,
              onChanged: (value) {
                final newContracts = Map<String, bool>.from(settings.contracts)
                  ..update(contract.name, (_) => value);
                provider.updateSettings(
                  settings.copyWith(
                    isActive: !newContracts.containsValue(true) ? false : null,
                    contracts: newContracts,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        SettingQuestion(
          tooltip: context.l10n.invertScoreDetails,
          label: context.l10n.invertScore,
          onTap: () => provider.updateSettings(
            settings.copyWith(invertScore: !settings.invertScore),
          ),
          input: MySwitch(
            isActive: settings.invertScore,
            onChanged: (value) =>
                provider.updateSettings(settings.copyWith(invertScore: value)),
          ),
        ),
      ],
    );
  }
}
