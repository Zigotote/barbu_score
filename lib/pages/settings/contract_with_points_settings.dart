import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/my_settings_card.dart';
import 'package:barbu_score/pages/settings/notifiers/change_contracts_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/my_switch.dart';
import '../../commons/widgets/setting_question.dart';
import '../rules/utils/change_settings.dart';
import 'widgets/change_contract_activation.dart';
import 'widgets/number_input.dart';

/// A page to edit the settings for a contract where each player has a different score
class ContractWithPointsSettingsPage extends ConsumerWidget
    with ChangeSettings {
  /// The contract that is being edited
  final ContractsInfo contract;

  const ContractWithPointsSettingsPage(this.contract, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(changeContractsSettingsProvider(contract))
            as ContractWithPointsSettings;
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
        children: [
          ChangeContractActivation(contract),
          SizedBox(height: 8),
          SettingQuestion(
            label: context.l10n.contractPoints(contract),
            onTap: numberFocusNode.requestFocus,
            input: NumberInput(
              value: settings.points,
              onChanged: (value) {
                if (value != settings.points) {
                  ref
                      .read(changeContractsSettingsProvider(contract).notifier)
                      .changeContractSettings(settings.copyWith(points: value));
                }
              },
              focusNode: numberFocusNode,
            ),
          ),
          if (settings.canInvertScore)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: SettingQuestion(
                tooltip: context.l10n.detailedInvertScoreRules(settings.points),
                label: context.l10n.invertScore,
                onTap: () => ref
                    .read(changeContractsSettingsProvider(contract).notifier)
                    .changeContractSettings(
                      settings.copyWith(invertScore: !settings.invertScore),
                    ),
                input: MySwitch(
                  isActive: settings.invertScore,
                  onChanged: (value) => ref
                      .read(changeContractsSettingsProvider(contract).notifier)
                      .changeContractSettings(
                        settings.copyWith(invertScore: value),
                      ),
                ),
              ),
            ),
          SizedBox(height: 16),
          ExpandableCard(
            type: ExpandableCardType.rules,
            children: [Text(context.l10n.contractRules(contract, settings))],
          ),
        ],
      ),
    );
  }
}
