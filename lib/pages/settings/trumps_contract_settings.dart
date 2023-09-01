import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/my_switch.dart';
import 'widgets/setting_question.dart';

/// A page to edit trumps contract settings
class TrumpsContractSettingsPage extends ConsumerWidget {
  const TrumpsContractSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(contractSettingsProvider(ContractsInfo.trumps));
    final settings = provider.settings as TrumpsContractSettings;
    return ContractSettingsPage(contract: ContractsInfo.trumps, children: [
      Text(
        "Contrats à jouer :",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      ...TrumpsContractSettings.availableContracts
          .map(
            (contract) => SettingQuestion(
              label: contract.displayName,
              input: MySwitch(
                isActive: settings.contracts[contract]!,
                onChanged: provider.modifySetting(
                  (value) => settings.contracts.update(contract, (_) => value),
                ),
              ),
            ),
          )
          .toList(),
    ]);
  }
}
