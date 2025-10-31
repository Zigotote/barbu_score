import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/providers/storage.dart';
import '../../commons/widgets/alert_dialog.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import 'utils/change_settings.dart';
import 'widgets/change_contract_activation.dart';
import 'widgets/my_switch.dart';
import 'widgets/setting_question.dart';

/// A page to edit salad contract settings
class SaladContractSettingsPage extends ConsumerStatefulWidget
    with ChangeSettings {
  const SaladContractSettingsPage({super.key});

  @override
  ConsumerState<SaladContractSettingsPage> createState() =>
      _SaladContractSettingsPageState();
}

class _SaladContractSettingsPageState
    extends ConsumerState<SaladContractSettingsPage> {
  late SaladContractSettings settings;

  @override
  void initState() {
    super.initState();
    settings =
        ref.read(storageProvider).getSettings(ContractsInfo.salad).copyWith()
            as SaladContractSettings;
    final storedGame = ref.read(storageProvider).getStoredGame();
    final playersWithContract = widget.playersWithContract(
      ContractsInfo.salad,
      storedGame,
    );
    if (playersWithContract.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => MyAlertDialog(
            context: context,
            title: context.l10n.alertContractPlayed,
            content: context.l10n.alertSaladContractPlayedBy(
              playersWithContract.join(", "),
            ),
            actions: [AlertDialogActionButton(text: "OK")],
          ),
        );
      });
    }
  }

  void _toggleSubcontractActivation(
    ContractsInfo subContract,
    SaladContractSettings settings,
  ) {
    settings.contracts[subContract.name] =
        !settings.contracts[subContract.name]!;
    if (!settings.contracts.containsValue(true)) {
      setState(() => settings.isActive = false);
    }
    widget.saveNewSettings(ref, ContractsInfo.salad, settings);
  }

  @override
  Widget build(BuildContext context) {
    return MyDefaultPage(
      appBar: MyAppBar(
        Column(
          children: [
            Text(context.l10n.settings),
            Text(context.l10n.contractName(ContractsInfo.salad)),
          ],
        ),
        context: context,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChangeContractActivation(ContractsInfo.salad, settings),
          SizedBox(height: 16),
          Semantics(
            header: true,
            child: Text(
              context.l10n.contractsToPlay,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          ...SaladContractSettings.availableContracts.map(
            (contract) => SettingQuestion(
              key: Key(contract.name),
              label: context.l10n.contractName(contract),
              onTap: () => _toggleSubcontractActivation(contract, settings),
              input: MySwitch(
                isActive: settings.contracts[contract.name]!,
                onChanged: (_) =>
                    _toggleSubcontractActivation(contract, settings),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SettingQuestion(
            tooltip: context.l10n.invertScoreDetails,
            label: context.l10n.invertScore,
            onTap: () {
              settings.invertScore = !settings.invertScore;
              widget.saveNewSettings(ref, ContractsInfo.salad, settings);
            },
            input: MySwitch(
              isActive: settings.invertScore,
              onChanged: (value) {
                settings.invertScore = value;
                widget.saveNewSettings(ref, ContractsInfo.salad, settings);
              },
            ),
          ),
        ],
      ),
    );
  }
}
