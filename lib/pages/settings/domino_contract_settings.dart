import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/domino_example.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit domino contract settings
class DominoContractSettingsPage extends ConsumerWidget {
  const DominoContractSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(contractSettingsProvider(ContractsInfo.domino));
    final settings = provider.settings as DominoContractSettings;
    return ContractSettingsPage(
      contract: ContractsInfo.domino,
      children: [
        SettingQuestion(
          label: "Score du premier joueur",
          input: NumberInput(
            points: settings.pointsFirstPlayer,
            onChanged: provider.modifySetting(
              (value) {
                settings.pointsFirstPlayer = value;
                settings.points = settings.generatePointsLists();
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        SettingQuestion(
          label: "Score du dernier joueur",
          input: NumberInput(
            points: settings.pointsLastPlayer,
            onChanged: provider.modifySetting(
              (value) {
                settings.pointsLastPlayer = value;
                settings.points = settings.generatePointsLists();
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        const DominoExample(),
      ],
    );
  }
}
