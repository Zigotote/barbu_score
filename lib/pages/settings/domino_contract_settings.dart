import 'package:flutter/material.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/utils/storage.dart';
import 'widgets/contract_settings.dart';
import 'widgets/domino_example.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit domino contract settings
class DominoContractSettingsPage extends StatefulWidget {
  const DominoContractSettingsPage({super.key});

  @override
  State<DominoContractSettingsPage> createState() =>
      _DominoContractSettingsPageState();
}

class _DominoContractSettingsPageState
    extends State<DominoContractSettingsPage> {
  /// The settings for this contract
  final DominoContractSettings _settings =
      MyStorage.getSettings(ContractsInfo.domino);

  @override
  Widget build(BuildContext context) {
    return ContractSettingsPage(
      contract: ContractsInfo.domino,
      settings: _settings,
      children: [
        SettingQuestion(
          label: "Score du premier joueur",
          input: NumberInput(
            points: _settings.pointsFirstPlayer,
            onChanged: (value) =>
                setState(() => _settings.pointsFirstPlayer = value),
          ),
        ),
        const SizedBox(height: 16),
        SettingQuestion(
          label: "Score du dernier joueur",
          input: NumberInput(
            points: _settings.pointsLastPlayer,
            onChanged: (value) =>
                setState(() => _settings.pointsLastPlayer = value),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Scores calculés"),
            IconButton(
              icon: const Icon(Icons.link),
              onPressed: () {
                debugPrint("not yet implemented");
              },
              style: IconButton.styleFrom(side: BorderSide.none),
            )
          ],
        ),
        const SizedBox(height: 8),
        DominoExample(settings: _settings),
      ],
    );
  }
}
