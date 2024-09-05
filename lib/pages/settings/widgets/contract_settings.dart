import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/widgets/default_page.dart';
import '../notifiers/contract_settings_provider.dart';
import 'my_switch.dart';
import 'setting_question.dart';

/// A base widget to edit a contract settings
class ContractSettingsPage extends ConsumerWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  /// The additionnal settings to display for the contract
  final List<Widget> children;

  const ContractSettingsPage({
    super.key,
    required this.contract,
    required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(contractSettingsProvider(contract));
    return DefaultPage(
      hasLeading: true,
      title: "Paramètres\n${contract.displayName}",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          SettingQuestion(
            label: "Activer le contrat",
            input: MySwitch(
              isActive: provider.settings.isActive,
              alertOnChange: provider.alertChangeIsActive(context),
              onChanged: provider.modifySetting(
                (bool value) => provider.settings.isActive = value,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ...children
        ],
      ),
    );
  }
}
