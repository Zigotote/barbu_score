import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/notifiers/storage.dart';
import '../../../commons/widgets/alert_dialog.dart';
import '../../../commons/widgets/default_page.dart';
import '../notifiers/contract_settings_provider.dart';
import 'my_switch.dart';
import 'setting_question.dart';

/// A base widget to edit a contract settings
class ContractSettingsPage extends ConsumerStatefulWidget {
  /// The contract that is beeing edited
  final ContractsInfo contract;

  /// The additionnal settings to display for the contract
  final List<Widget> children;

  /// The indactor to know if is active switch state should be blocked, or if it can be updated
  final bool blockIsActive;

  const ContractSettingsPage(
      {super.key,
      required this.contract,
      required this.children,
      this.blockIsActive = false});

  @override
  ConsumerState<ContractSettingsPage> createState() => _ContractSettingsPage();
}

class _ContractSettingsPage extends ConsumerState<ContractSettingsPage> {
  @override
  void initState() {
    super.initState();
    if (!ref.read(canModifySettingsProvider)) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => MyAlertDialog(
            context: context,
            title: "Modification des paramètres",
            content:
                "Une partie est déjà sauvegardée sur l'appareil. Les paramètres des contrats peuvent uniquement être consultés. Pour les modifier, la partie en cours doit être supprimée.",
            actions: [
              AlertDialogActionButton(
                text: 'Consulter',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              AlertDialogActionButton(
                isDestructive: true,
                text: 'Supprimer',
                onPressed: () {
                  ref.read(storageProvider).deleteGame();
                  ref
                      .read(canModifySettingsProvider.notifier)
                      .update((state) => true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(contractSettingsProvider(widget.contract));
    return DefaultPage(
      hasLeading: true,
      title: "Paramètres\n${widget.contract.displayName}",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          SettingQuestion(
            label: "Activer le contrat",
            input: MySwitch(
              isActive: provider.settings.isActive,
              onChanged: widget.blockIsActive == false
                  ? provider.modifySetting(
                      (bool value) => provider.settings.isActive = value,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 32),
          ...widget.children
        ],
      ),
    );
  }
}
