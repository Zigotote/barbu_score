import 'package:flutter/material.dart';

import '../../commons/models/contract_info.dart';
import 'widgets/contract_settings.dart';
import 'widgets/my_switch.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit the settings for a contract where each player has a different score
class IndividualScoresContractSettings extends StatelessWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  const IndividualScoresContractSettings(this.contract, {super.key});

  @override
  Widget build(BuildContext context) {
    final String itemName = contract.displayName.replaceFirst("Sans ", "");
    return ContractSettingsPage(
      contract: contract,
      settings: [
        SettingQuestion(
          label: "Points par ${itemName.replaceFirst(RegExp(r's$'), "")}",
          input: NumberInput(contract),
        ),
        SettingQuestion(
          tooltip:
              "Si un joueur remporte la totalité des $itemName, son score devient négatif.",
          label: "Inversion du score",
          input: MySwitch(
            isActive: false,
            onChanged: (bool value) {},
          ),
        ),
      ],
    );
  }
}
