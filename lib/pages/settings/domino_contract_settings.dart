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
          label: "Score minimum",
          input: NumberInput(
            points: _settings.pointsMin,
            onChanged: (value) => setState(() => _settings.pointsMin = value),
          ),
        ),
        const SizedBox(height: 16),
        SettingQuestion(
          label: "Score maximum",
          input: NumberInput(
            points: _settings.pointsMax,
            onChanged: (value) => setState(() => _settings.pointsMax = value),
          ),
        ),
        const SizedBox(height: 32),
        DominoExample(settings: _settings),
      ],
    );
  }
}
