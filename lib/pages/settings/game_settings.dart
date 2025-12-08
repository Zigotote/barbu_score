import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/providers/storage.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import 'widgets/my_switch.dart';
import 'widgets/setting_question.dart';

/// A page to edit game settings
class GameSettingsPage extends ConsumerWidget {
  const GameSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(storageProvider).getGameSettings();
    return MyDefaultPage(
      appBar: MyAppBar(
        Column(
          children: [Text(context.l10n.settings), Text(context.l10n.game)],
        ),
        context: context,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingQuestion(
            label: context.l10n.gameScoreObjective,
            input: MySwitch(
              isActive: settings.goalIsMinScore,
              onChanged: (value) => ref
                  .read(storageProvider)
                  .saveGameSettings(settings.copyWith(goalIsMinScore: value)),
            ),
            onTap: () => ref
                .read(storageProvider)
                .saveGameSettings(
                  settings.copyWith(goalIsMinScore: !settings.goalIsMinScore),
                ),
          ),
          /*const SizedBox(height: 8),
          ...SaladContractSettings.availableContracts.map(
            (contract) => SettingQuestion(
              key: Key(contract.name),
              label: context.l10n.contractName(contract),
              onTap: () => _toggleSubcontractActivation(contract, settings),
              input: MySwitch(
                isActive: settings.contracts[contract.name]!,
                onChanged: (_) =>
                    _toggleSubcontractActivation(contract, settings),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
