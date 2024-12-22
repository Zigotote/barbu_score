import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/providers/storage.dart';
import '../../../commons/widgets/alert_dialog.dart';

final contractSettingsProvider = ChangeNotifierProvider.family
    .autoDispose<ContractSettingsNotifier, ContractsInfo>(
  (ref, contractsInfo) => ContractSettingsNotifier(
    ref.read(storageProvider),
    contract: contractsInfo,
  ),
);

class ContractSettingsNotifier with ChangeNotifier {
  final MyStorage storage;

  final ContractsInfo contract;

  /// The settings of the current contract
  final AbstractContractSettings settings;

  ContractSettingsNotifier(this.storage, {required this.contract})
      : settings = storage.getSettings(contract).copy();

  /// Returns the name of the players who played this contract, or empty list if no data found or game is finished
  List<String> get playersWithContract {
    final storedGame = storage.getStoredGame();
    final playersWithContract =
        storedGame?.getPlayersWithPlayedContract(contract);
    if (storedGame?.isFinished == true || playersWithContract == null) {
      return [];
    }
    return playersWithContract;
  }

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
        actions: [AlertDialogActionButton(text: "Ok")],
      );
    }
    if (settings.isActive && (playersWithContract.isNotEmpty)) {
      return MyAlertDialog(
        context: context,
        title: "Le contrat a déjà été joué",
        content:
            "Le contrat a déjà été joué par ${playersWithContract.join(", ")}. S'il est désactivé il sera supprimé de la partie et ${playersWithContract.length > 1 ? "ces joueurs devront" : "ce joueur devra"} choisir un contrat supplémentaire en fin de partie.",
        actions: [
          AlertDialogActionButton(text: "Conserver"),
          AlertDialogActionButton(
            text: "Désactiver",
            isDestructive: true,
            onPressed: () {
              modifySetting((_) => settings.isActive = false)(null);
            },
          ),
        ],
      );
    }
    return null;
  }
}
