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
    return ContractSettingsPage(
      contract: ContractsInfo.trumps,
      blockIsActive: !settings.contracts.containsValue(true),
      children: [
        Text(
          "Contrats à jouer :",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...TrumpsContractSettings.availableContracts.map(
          (contract) => SettingQuestion(
            key: Key(contract.name),
            label: contract.displayName,
            input: MySwitch(
              isActive: settings.contracts[contract.name]!,
              onChanged: provider.modifySetting(
                (value) {
                  settings.contracts.update(contract.name, (_) => value);
                  // Deactivate trumps contract if no active contract inside it
                  if (!settings.contracts.containsValue(true)) {
                    settings.isActive = false;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
