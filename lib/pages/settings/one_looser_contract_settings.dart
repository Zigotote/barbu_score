import 'package:flutter/material.dart';

import '../../commons/models/contract_info.dart';
import 'widgets/contract_settings.dart';
import 'widgets/number_input.dart';
import 'widgets/setting_question.dart';

/// A page to edit one looser contract settings (like barbu or no last trick)
class OneLooserContractSettings extends StatelessWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  const OneLooserContractSettings(this.contract, {super.key});

  @override
  Widget build(BuildContext context) {
    return ContractSettingsPage(
      contract: contract,
      settings: [
        SettingQuestion(
          label: "Points du contrat",
          input: NumberInput(contract),
        )
      ],
    );
  }
}
