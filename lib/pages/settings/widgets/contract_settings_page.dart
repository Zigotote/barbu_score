import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/expandable_card.dart';
import 'package:barbu_score/pages/settings/notifiers/change_contracts_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/providers/log.dart';
import '../../../commons/providers/storage.dart';
import '../../../commons/widgets/alert_dialog.dart';
import '../../../commons/widgets/my_appbar.dart';
import '../../../commons/widgets/my_default_page.dart';
import 'change_contract_activation.dart';

/// The layout of the page to edit the settings for a contract
class ContractSettingsPage extends ConsumerStatefulWidget {
  /// The contract that is being edited
  final ContractsInfo contract;

  /// The list of widgets to edits settings for this contract
  final List<Widget> settingsChildren;

  const ContractSettingsPage(
    this.contract, {
    super.key,
    required this.settingsChildren,
  });

  @override
  ConsumerState<ContractSettingsPage> createState() =>
      _ContractSettingsPageState();
}

class _ContractSettingsPageState extends ConsumerState<ContractSettingsPage> {
  @override
  void initState() {
    super.initState();
    final storedGame = ref.read(storageProvider).getStoredGame();
    final isContractActive = ref
        .read(storageProvider)
        .getSettings(widget.contract)
        .isActive;
    final playersWithContract = storedGame?.getPlayersWithPlayedContract(
      widget.contract,
    );
    if (isContractActive &&
        (storedGame?.isFinished == false ||
            playersWithContract?.isEmpty == false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => MyAlertDialog(
            context: context,
            title: context.l10n.alertContractPlayed,
            content: context.l10n.alertContractPlayedBy(
              playersWithContract!.join(", "),
            ),
            actions: [AlertDialogActionButton(text: "OK")],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(
      changeContractsSettingsProvider(widget.contract),
    );
    return PopScope(
      onPopInvokedWithResult: (_, _) {
        final storage = ref.read(storageProvider);
        final log = ref.read(logProvider);

        final newContractSettings = ref.read(
          changeContractsSettingsProvider(widget.contract),
        );
        if (storage.getSettings(widget.contract) != newContractSettings) {
          storage.saveSettings(widget.contract, newContractSettings);
          log.info("MyRules: save new contract settings $newContractSettings");
          log.sendAnalyticEvent(
            "modify_settings",
            parameters: {"contract": widget.contract.name},
          );
        }
      },
      child: MyDefaultPage(
        appBar: MyAppBar(
          Column(
            children: [
              Text(context.l10n.settings),
              Text(context.l10n.contractName(widget.contract)),
            ],
          ),
          context: context,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChangeContractActivation(widget.contract),
            SizedBox(height: 8),
            ...widget.settingsChildren,
            SizedBox(height: 16),
            ExpandableCard.type(
              type: ExpandableCardType.rules,
              children: [
                Text(context.l10n.contractRules(widget.contract, settings)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
