import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/settings/notifiers/change_contracts_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/widgets/alert_dialog.dart';
import '../../../commons/widgets/my_switch.dart';
import '../../../commons/widgets/setting_question.dart';

class ChangeContractActivation extends ConsumerWidget {
  final ContractsInfo contract;

  const ChangeContractActivation(this.contract, {super.key});

  /// If the contract is deactivated but has been played, shows an alert before to confirm the deactivation.
  /// Otherwise, toggles the contract state
  void toggleIsActiveIfPossible(
    BuildContext context,
    WidgetRef ref,
    ContractsInfo contract,
    AbstractContractSettings settings,
  ) async {
    if (settings is SaladContractSettings &&
        !settings.contracts.containsValue(true)) {
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
    } else {
      _toggleAndSaveIsActive(ref, settings);
    }
  }

  /// Toggle contract activation and saves it
  void _toggleAndSaveIsActive(
    WidgetRef ref,
    AbstractContractSettings settings,
  ) {
    ref
        .read(changeContractsSettingsProvider(contract).notifier)
        .changeContractSettings(
          settings.copyWith(isActive: !settings.isActive),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(changeContractsSettingsProvider(contract));
    return SettingQuestion(
      label: context.l10n.activateContract,
      onTap: () => toggleIsActiveIfPossible(context, ref, contract, settings),
      input: MySwitch(
        isActive: settings.isActive,
        onChanged: (value) =>
            toggleIsActiveIfPossible(context, ref, contract, settings),
      ),
    );
  }
}
