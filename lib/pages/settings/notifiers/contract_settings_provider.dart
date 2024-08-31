import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/notifiers/storage.dart';

final contractSettingsProvider = ChangeNotifierProvider.family
    .autoDispose<ContractSettingsNotifier, ContractsInfo>(
  (ref, contractsInfo) => ContractSettingsNotifier(
    ref.read(storageProvider).getSettings(contractsInfo).copy(),
    playersWithContract: ref
        .read(storageProvider)
        .getStoredGame()
        ?.getPlayersWithPlayedContract(contractsInfo),
  ),
);

class ContractSettingsNotifier with ChangeNotifier {
  /// The settings of the current contract
  final AbstractContractSettings settings;

  /// The name of the players who played this contract
  final List<String>? playersWithContract;

  ContractSettingsNotifier(this.settings, {required this.playersWithContract});

  Function(T) modifySetting<T>(Function(T) func) {
    return (value) {
      func.call(value);
      notifyListeners();
    };
  }

  MyAlertDialog? alertChangeIsActive(BuildContext context) {
    final typedSettings = settings;
    if (typedSettings is TrumpsContractSettings &&
        !typedSettings.contracts.containsValue(true)) {
      return MyAlertDialog(
        context: context,
        title: "Activation impossible",
        content:
            "La ${ContractsInfo.trumps.displayName} doit posséder au moins un contrat à jouer pour être activée.",
        actions: [
          AlertDialogActionButton(
            text: "Ok",
            onPressed: Navigator.of(context).pop,
          )
        ],
      );
    }
    if (settings.isActive && (playersWithContract?.isNotEmpty ?? false)) {
      return MyAlertDialog(
        context: context,
        title: "Le contrat a déjà été joué",
        content:
            "Le contrat a déjà été joué par ${playersWithContract!.join(", ")}. S'il est désactivé il sera supprimé de la partie et ${playersWithContract!.length > 1 ? "ces joueurs devront" : "ce joueur devra"} choisir un contrat supplémentaire en fin de partie.",
        actions: [
          AlertDialogActionButton(
            text: "Conserver",
            onPressed: Navigator.of(context).pop,
          ),
          AlertDialogActionButton(
            text: "Désactiver",
            isDestructive: true,
            onPressed: () {
              modifySetting((_) => settings.isActive = false)(null);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
    return null;
  }
}
