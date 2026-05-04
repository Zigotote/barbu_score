import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/settings/notifiers/change_contracts_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/providers/storage.dart';
import '../../commons/widgets/alert_dialog.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/my_settings_card.dart';
import '../../commons/widgets/my_switch.dart';
import '../../commons/widgets/setting_question.dart';
import '../rules/utils/change_settings.dart';
import 'widgets/change_contract_activation.dart';

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
        ref.read(changeContractsSettingsProvider(ContractsInfo.salad))
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
      //TODO Océane to reactivate
      // setState(() => settings.isActive = false);
    }
    ref
        .read(changeContractsSettingsProvider(ContractsInfo.salad).notifier)
        .changeContractSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = ref.read(storageProvider).getGameSettings();
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
          ChangeContractActivation(ContractsInfo.salad),
          SizedBox(height: 8),
          Semantics(
            header: true,
            child: Text(
              context.l10n.contractsToPlay,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 4),
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
          SizedBox(height: 8),
          SettingQuestion(
            tooltip: context.l10n.detailedInvertScoreRules(),
            label: context.l10n.invertScore,
            onTap: () => ref
                .read(
                  changeContractsSettingsProvider(ContractsInfo.salad).notifier,
                )
                .changeContractSettings(
                  settings.copyWith(invertScore: !settings.invertScore),
                ),
            input: MySwitch(
              isActive: settings.invertScore,
              onChanged: (value) => ref
                  .read(
                    changeContractsSettingsProvider(
                      ContractsInfo.salad,
                    ).notifier,
                  )
                  .changeContractSettings(
                    settings.copyWith(invertScore: !settings.invertScore),
                  ),
            ),
          ),
          SizedBox(height: 16),
          // TODO Océane les règles ne se mettent pas à jour quand on change les paramètres du contrat ici (ça se fait bien dans la page de règle par contre, juste un petit soucis de réactivité
          ExpandableCard(
            type: ExpandableCardType.rules,
            children: [
              Text(context.l10n.contractRules(ContractsInfo.salad, settings)),
            ],
          ),
        ],
      ),
    );
  }
}
