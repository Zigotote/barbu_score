import 'package:flutter/material.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/utils/storage.dart';
import 'widgets/contract_settings.dart';
import 'widgets/my_switch.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit the settings for a contract where each player has a different score
class IndividualScoresContractSettingsPage extends StatelessWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  /// The settings for this contract
  final IndividualScoresContractSettings _settings;

  IndividualScoresContractSettingsPage(this.contract, {super.key})
      : _settings = MyStorage.getSettings(contract);

  @override
  Widget build(BuildContext context) {
    final String itemName = contract.displayName.replaceFirst("Sans ", "");
    return ContractSettingsPage(
      contract: contract,
      settings: _settings,
      children: [
        SettingQuestion(
          label: "Points par ${itemName.replaceFirst(RegExp(r's$'), "")}",
          input: NumberInput(
            points: _settings.points,
            onChanged: (value) => _settings.points = value,
          ),
        ),
        SettingQuestion(
          tooltip:
              "Si un joueur remporte la totalité des $itemName, son score devient négatif.",
          label: "Inversion du score",
          input: MySwitch(
            isActive: _settings.invertScore,
            onChanged: (bool value) => _settings.invertScore = value,
          ),
        ),
      ],
    );
  }
}
