import 'package:barbu_score/commons/widgets/default_page.dart';
import 'package:barbu_score/pages/settings/widgets/setting_question.dart';
import 'package:flutter/material.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/utils/storage.dart';
import 'my_switch.dart';

/// A base widget to edit a contract settings (like barbu or no last trick)
class ContractSettingsPage extends StatefulWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  /// The settings of this contract
  final AbstractContractSettings settings;

  /// The additionnal settings to display for the contract
  final List<Widget> children;

  const ContractSettingsPage(
      {super.key,
      required this.contract,
      required this.settings,
      required this.children});

  @override
  State<ContractSettingsPage> createState() => _ContractSettingsPage();
}

class _ContractSettingsPage extends State<ContractSettingsPage> {
  @override
  void dispose() {
    super.dispose();
    MyStorage.saveSettings(widget.contract, widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      hasLeading: true,
      title: "Paramètres\n${widget.contract.displayName}",
      content: Column(
        children: [
          const SizedBox(height: 24),
          SettingQuestion(
            label: "Activer le contrat",
            input: MySwitch(
              isActive: widget.settings.isActive,
              onChanged: (bool value) => widget.settings.isActive = value,
            ),
          ),
          ...widget.children
              .map((setting) => Padding(
                  padding: const EdgeInsets.only(top: 32), child: setting))
              .toList()
        ],
      ),
    );
  }
}
