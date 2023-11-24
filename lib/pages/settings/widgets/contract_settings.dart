import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/utils/storage.dart';
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
    var storedGame = MyStorage.getStoredGame();
    if (storedGame?.isFinished == true) {
      MyStorage.deleteGame();
      storedGame = null;
    }
    if (storedGame != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final isAnswered = await showDialog(
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
                  ref
                      .read(contractSettingsProvider(widget.contract))
                      .canModify = false;
                  Navigator.of(context).pop(true);
                },
              ),
              AlertDialogActionButton(
                isDestructive: true,
                text: 'Supprimer',
                onPressed: () {
                  MyStorage.deleteGame();
                  ref
                      .read(contractSettingsProvider(widget.contract))
                      .canModify = true;
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
        if (isAnswered == null) {
          ref.read(contractSettingsProvider(widget.contract)).canModify = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(contractSettingsProvider(widget.contract));
    return DefaultPage(
      hasLeading: true,
      title: "Paramètres\n${widget.contract.displayName}",
      content: SingleChildScrollView(
        child: Column(
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
      ),
    );
  }
}
