import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit one looser contract settings (like barbu or no last trick)
class OneLooserContractSettingsPage extends ConsumerWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  const OneLooserContractSettingsPage(this.contract, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(contractSettingsProvider(contract));
    final settings = provider.settings as PointsContractSettings;
    return ContractSettingsPage(
      contract: contract,
      children: [
        SettingQuestion(
          label: "Points du contrat",
          input: NumberInput(
            points: settings.points,
            onChanged: provider.modifySetting(
              (value) => settings.points = value,
            ),
          ),
        )
      ],
    );
  }
}
