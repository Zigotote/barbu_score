import 'package:flutter/material.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/utils/storage.dart';
import 'widgets/contract_settings.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit one looser contract settings (like barbu or no last trick)
class OneLooserContractSettingsPage extends StatelessWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  /// The settings for this contract
  final PointsContractSettings _settings;

  OneLooserContractSettingsPage(this.contract, {super.key})
      : _settings = MyStorage.getSettings(contract);

  @override
  Widget build(BuildContext context) {
    return ContractSettingsPage(
      contract: contract,
      settings: _settings,
      children: [
        SettingQuestion(
          label: "Points du contrat",
          input: NumberInput(
            points: _settings.points,
            onChanged: (value) => _settings.points = value,
          ),
        )
      ],
    );
  }
}
