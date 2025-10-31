import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/widgets/alert_dialog.dart';
import '../../../commons/widgets/my_appbar.dart';
import '../../../commons/widgets/my_default_page.dart';
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
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        SettingQuestion(
          label: context.l10n.activateContract,
          onTap: () =>
              _changeIsActive(context, provider, !provider.settings.isActive),
          input: MySwitch(
            isActive: provider.settings.isActive,
            onChanged: (value) => _changeIsActive(context, provider, value),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
    return MyDefaultPage(
      appBar: MyAppBar(
        Column(
          children: [
            Text(context.l10n.settings),
            Text(context.l10n.contractName(contract)),
          ],
        ),
        context: context,
      ),
      content: content,
    );
  }

  /// If the contract is deactivated but has been played, shows an alert before to confirm the deactivation.
  /// Otherwise, toggles the contract state
  void _changeIsActive(
    BuildContext context,
    ContractSettingsNotifier provider,
    bool isActive,
  ) async {
    final typedSettings = provider.settings;
    if (typedSettings is SaladContractSettings &&
        !typedSettings.contracts.containsValue(true)) {
      return showDialog(
        context: context,
        builder: (_) => MyAlertDialog(
          context: context,
          title: context.l10n.alertCannotActivateSalad,
          content: context.l10n.alertCannotActivateSaladDetails,
          closeOnAction: false,
          actions: [
            AlertDialogActionButton(
              text: "OK",
              onPressed: () => context.pop(false),
            ),
          ],
        ),
      );
    } else if (!isActive && (provider.playersWithContract.isNotEmpty)) {
      return showDialog(
        context: context,
        builder: (_) => MyAlertDialog(
          context: context,
          title: context.l10n.alertContractPlayed,
          content: context.l10n.alertContractPlayedBy(
            provider.playersWithContract.join(", "),
            provider.playersWithContract.length,
          ),
          closeOnAction: false,
          actions: [
            AlertDialogActionButton(
              text: context.l10n.keep,
              onPressed: () => context.pop(false),
            ),
            AlertDialogActionButton(
              text: context.l10n.deactivate,
              isDestructive: true,
              onPressed: () {
                provider.updateSettings(
                  provider.settings.copyWith(isActive: false),
                );
                context.pop(true);
              },
            ),
          ],
        ),
      );
    } else {
      provider.updateSettings(provider.settings.copyWith(isActive: isActive));
    }
  }
}
