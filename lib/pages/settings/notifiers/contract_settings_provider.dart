import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/notifiers/storage.dart';

final contractSettingsProvider = ChangeNotifierProvider.family
    .autoDispose<ContractSettingsNotifier, ContractsInfo>(
  (ref, contractsInfo) => ContractSettingsNotifier(
    ref.read(storageProvider).getSettings(contractsInfo),
  ),
);

class ContractSettingsNotifier with ChangeNotifier {
  /// The settings of the current contract
  final AbstractContractSettings settings;

  /// The indicator to know if the settings can be modified or not
  bool _canModify = true;

  ContractSettingsNotifier(this.settings);

  bool get canModify => _canModify;

  set canModify(bool value) {
    _canModify = value;
    notifyListeners();
  }

  Function(T)? modifySetting<T>(Function(T) func) {
    return canModify ? (value) => func.call(value) : null;
  }
}
