import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/providers/storage.dart';

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
}
