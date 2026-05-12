import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/settings/notifiers/change_contracts_settings.dart';
import 'package:barbu_score/pages/settings/widgets/contract_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/widgets/my_switch.dart';
import '../../commons/widgets/setting_question.dart';

/// A page to edit salad contract settings
class SaladContractSettingsPage extends ConsumerWidget {
  const SaladContractSettingsPage({super.key});

  void _toggleSubcontractActivation(
    WidgetRef ref,
    ContractsInfo subContract,
    SaladContractSettings settings,
  ) {
    settings = settings.copyWith(
      contracts: Map.from(settings.contracts)
        ..update(subContract.name, (value) => !value),
    );
    if (!settings.contracts.containsValue(true)) {
      settings = settings.copyWith(isActive: false);
    }
    ref
        .read(changeContractsSettingsProvider(ContractsInfo.salad).notifier)
        .changeContractSettings(settings);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(changeContractsSettingsProvider(ContractsInfo.salad))
            as SaladContractSettings;
    return ContractSettingsPage(
      ContractsInfo.salad,
      settingsChildren: [
        Semantics(
          header: true,
          child: Text(
            context.l10n.contractsToPlay,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 4),
        ...SaladContractSettings.availableContracts.map(
          (contract) => SettingQuestion(
            key: Key(contract.name),
            label: context.l10n.contractName(contract),
            onTap: () => _toggleSubcontractActivation(ref, contract, settings),
            input: MySwitch(
              isActive: settings.contracts[contract.name]!,
              onChanged: (_) =>
                  _toggleSubcontractActivation(ref, contract, settings),
            ),
          ),
        ),
        SizedBox(height: 8),
        SettingQuestion(
          tooltip: context.l10n.detailedInvertScoreRules(),
          label: context.l10n.invertScore,
          onTap: () => ref
              .read(
                changeContractsSettingsProvider(ContractsInfo.salad).notifier,
              )
              .changeContractSettings(
                settings.copyWith(invertScore: !settings.invertScore),
              ),
          input: MySwitch(
            isActive: settings.invertScore,
            onChanged: (value) => ref
                .read(
                  changeContractsSettingsProvider(ContractsInfo.salad).notifier,
                )
                .changeContractSettings(
                  settings.copyWith(invertScore: !settings.invertScore),
                ),
          ),
        ),
      ],
    );
  }
}
