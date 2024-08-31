import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/widgets/alert_dialog.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/my_switch.dart';
import 'widgets/setting_question.dart';

/// A page to edit trumps contract settings
class TrumpsContractSettingsPage extends ConsumerStatefulWidget {
  const TrumpsContractSettingsPage({super.key});

  @override
  ConsumerState<TrumpsContractSettingsPage> createState() =>
      _TrumpsContractSettingsPageState();
}

class _TrumpsContractSettingsPageState
    extends ConsumerState<TrumpsContractSettingsPage> {
  @override
  void initState() {
    super.initState();
    final playersWithContract = ref
        .read(contractSettingsProvider(ContractsInfo.trumps))
        .playersWithContract;
    if (playersWithContract?.isNotEmpty ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => MyAlertDialog(
            context: context,
            title: "Le contrat a déjà été joué",
            content:
                "Le contrat a déjà été joué par ${playersWithContract!.join(", ")}. Toute modification dans les paramètres de ce contrat aura des répercussions sur les contrats sauvegardés.",
            actions: [AlertDialogActionButton(text: "Ok")],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(contractSettingsProvider(ContractsInfo.trumps));
    final settings = provider.settings as TrumpsContractSettings;
    return ContractSettingsPage(
      contract: ContractsInfo.trumps,
      children: [
        Text(
          "Contrats à jouer :",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...TrumpsContractSettings.availableContracts.map(
          (contract) => SettingQuestion(
            key: Key(contract.name),
            label: contract.displayName,
            input: MySwitch(
              isActive: settings.contracts[contract.name]!,
              onChanged: provider.modifySetting(
                (value) {
                  settings.contracts.update(contract.name, (_) => value);
                  // Deactivate trumps contract if no active contract inside it
                  if (!settings.contracts.containsValue(true)) {
                    settings.isActive = false;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
