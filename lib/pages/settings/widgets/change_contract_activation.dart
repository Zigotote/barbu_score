import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/providers/storage.dart';
import '../../../commons/widgets/alert_dialog.dart';
import '../utils/change_settings.dart';
import 'my_switch.dart';
import 'setting_question.dart';

class ChangeContractActivation extends ConsumerWidget with ChangeSettings {
  final ContractsInfo contract;
  final AbstractContractSettings settings;

  ChangeContractActivation(this.contract, this.settings, {super.key});

  /// If the contract is deactivated but has been played, shows an alert before to confirm the deactivation.
  /// Otherwise, toggles the contract state
  void toggleIsActiveIfPossible(BuildContext context, WidgetRef ref,
      ContractsInfo contract, AbstractContractSettings settings) async {
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
            )
          ],
        ),
      );
    } else {
      final players = playersWithContract(
        contract,
        ref.read(storageProvider).getStoredGame(),
      );
      if (settings.isActive && players.isNotEmpty) {
        return showDialog(
          context: context,
          builder: (_) => MyAlertDialog(
            context: context,
            closeOnAction: false,
            title: context.l10n.alertContractPlayed,
            content: context.l10n.alertContractPlayedBy(
              players.join(", "),
              players.length,
            ),
            actions: [
              AlertDialogActionButton(
                text: context.l10n.keep,
                onPressed: () => context.pop(false),
              ),
              AlertDialogActionButton(
                text: context.l10n.deactivate,
                isDestructive: true,
                onPressed: () {
                  context.pop(true);
                  _toggleAndSaveIsActive(ref, contract, settings);
                },
              ),
            ],
          ),
        );
      } else {
        _toggleAndSaveIsActive(ref, contract, settings);
      }
    }
  }

  /// Toggle contract activation and saves it
  void _toggleAndSaveIsActive(WidgetRef ref, ContractsInfo contract,
      AbstractContractSettings settings) {
    settings.isActive = !settings.isActive;
    saveNewSettings(ref, contract, settings);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingQuestion(
      label: context.l10n.activateContract,
      onTap: () => toggleIsActiveIfPossible(
        context,
        ref,
        contract,
        settings,
      ),
      input: MySwitch(
        isActive: settings.isActive,
        onChanged: (value) => toggleIsActiveIfPossible(
          context,
          ref,
          contract,
          settings,
        ),
      ),
    );
  }
}
