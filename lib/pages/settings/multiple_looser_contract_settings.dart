import 'package:barbu_score/commons/utils/l10n_extensions.dart';
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
class MultipleLooserContractSettingsPage extends ConsumerWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  const MultipleLooserContractSettingsPage(this.contract, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(contractSettingsProvider(contract));
    final settings = provider.settings as MultipleLooserContractSettings;
    final numberFocusNode = FocusNode();
    return ContractSettingsPage(
      contract: contract,
      children: [
        SettingQuestion(
          label: context.l10n.pointsBy(context.l10n.itemsName(contract)),
          onTap: numberFocusNode.requestFocus,
          input: NumberInput(
            points: settings.points,
            onChanged: (value) =>
                provider.updateSettings(settings.copyWith(points: value)),
            focusNode: numberFocusNode,
          ),
        ),
        const SizedBox(height: 16),
        SettingQuestion(
          tooltip: context.l10n.invertScoreDetails,
          label: context.l10n.invertScore,
          onTap: () => provider.updateSettings(
            settings.copyWith(invertScore: !settings.invertScore),
          ),
          input: MySwitch(
            isActive: settings.invertScore,
            onChanged: (value) => provider.updateSettings(
              settings.copyWith(invertScore: value),
            ),
          ),
        ),
      ],
    );
  }
}
