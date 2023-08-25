import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/widgets/default_page.dart';
import 'package:barbu_score/pages/settings/widgets/setting_question.dart';
import 'package:flutter/material.dart';

import 'my_switch.dart';

/// A base widget to edit a contract settings (like barbu or no last trick)
class ContractSettingsPage extends StatelessWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  /// The additionnal settings to display for the contract
  final List<Widget> settings;

  const ContractSettingsPage(
      {super.key, required this.contract, required this.settings});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      hasLeading: true,
      title: "Paramètres\n${contract.displayName}",
      content: Column(
        children: [
          const SizedBox(height: 24),
          SettingQuestion(
            label: "Activer le contrat",
            input: MySwitch(
              isActive: false,
              onChanged: (bool value) {},
            ),
          ),
          ...settings
              .map((setting) => Padding(
                  padding: const EdgeInsets.only(top: 32), child: setting))
              .toList()
        ],
      ),
    );
  }
}
