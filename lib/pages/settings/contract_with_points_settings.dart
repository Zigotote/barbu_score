import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/providers/storage.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import 'utils/change_settings.dart';
import 'widgets/change_contract_activation.dart';
import 'widgets/my_switch.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit the settings for a contract where each player has a different score
class ContractWithPointsSettingsPage extends ConsumerWidget
    with ChangeSettings {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  const ContractWithPointsSettingsPage(this.contract, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.read(storageProvider).getSettings(contract).copyWith()
            as ContractWithPointsSettings;
    final gameSettings = ref.read(storageProvider).getGameSettings();
    final numberFocusNode = FocusNode();
    return MyDefaultPage(
      appBar: MyAppBar(
        Column(
          children: [
            Text(context.l10n.settings),
            Text(context.l10n.contractName(contract)),
          ],
        ),
        context: context,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          ChangeContractActivation(contract, settings),
          SettingQuestion(
            label: context.l10n.contractPoints,
            onTap: numberFocusNode.requestFocus,
            input: NumberInput(
              points: settings.points,
              onChanged: (value) {
                if (value != settings.points) {
                  settings.points = value;
                  saveNewSettings(ref, contract, settings);
                }
              },
              focusNode: numberFocusNode,
            ),
          ),
          if (settings.canInvertScore)
            SettingQuestion(
              tooltip: context.l10n.detailedInvertScoreRules(gameSettings),
              label: context.l10n.invertScore,
              onTap: () {
                settings.invertScore = !settings.invertScore;
                saveNewSettings(ref, contract, settings);
              },
              input: MySwitch(
                isActive: settings.invertScore,
                onChanged: (value) {
                  settings.invertScore = value;
                  saveNewSettings(ref, contract, settings);
                },
              ),
            ),
        ],
      ),
    );
  }
}
