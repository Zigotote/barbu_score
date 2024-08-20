import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/notifiers/storage.dart';

final canModifySettingsProvider = StateProvider.autoDispose(
  (ref) => !ref.read(storageProvider).hasStoredGame(),
);

final contractSettingsProvider = ChangeNotifierProvider.family
    .autoDispose<ContractSettingsNotifier, ContractsInfo>(
  (ref, contractsInfo) => ContractSettingsNotifier(
    ref.watch(canModifySettingsProvider),
    ref.read(storageProvider).getSettings(contractsInfo).copy(),
  ),
);

class ContractSettingsNotifier with ChangeNotifier {
  /// The indicator to know if settings can be modified or not
  final bool canModify;

  /// The settings of the current contract
  final AbstractContractSettings settings;

  ContractSettingsNotifier(this.canModify, this.settings);

  Function(T)? modifySetting<T>(Function(T) func) {
    return canModify
        ? (value) {
            func.call(value);
            notifyListeners();
          }
        : null;
  }
}
