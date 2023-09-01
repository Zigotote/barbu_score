import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/my_switch.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit the settings for a contract where each player has a different score
class IndividualScoresContractSettingsPage extends ConsumerWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  const IndividualScoresContractSettingsPage(this.contract, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String itemName = contract.displayName.replaceFirst("Sans ", "");
    final provider = ref.watch(contractSettingsProvider(contract));
    final settings = provider.settings as IndividualScoresContractSettings;
    return ContractSettingsPage(
      contract: contract,
      children: [
        SettingQuestion(
          label: "Points par ${itemName.replaceFirst(RegExp(r's$'), "")}",
          input: NumberInput(
            points: settings.points,
            onChanged: provider.modifySetting(
              (value) => settings.points = value,
            ),
          ),
        ),
        const SizedBox(height: 32),
        SettingQuestion(
          tooltip:
              "Si un joueur remporte la totalité des $itemName, son score devient négatif.",
          label: "Inversion du score",
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
