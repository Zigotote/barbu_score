import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/utils/storage.dart';

final contractSettingsProvider = ChangeNotifierProvider.family
    .autoDispose<ContractSettingsNotifier, ContractsInfo>(
  (ref, contractsInfo) => ContractSettingsNotifier(contractsInfo),
);

class ContractSettingsNotifier with ChangeNotifier {
  /// The settings of the current contract
  final AbstractContractSettings settings;

  /// The indicator to know if the settings can be modified or not
  bool _canModify = true;

  ContractSettingsNotifier(ContractsInfo contract)
      : settings = MyStorage.getSettings(contract);

  bool get canModify => _canModify;

  set canModify(bool value) {
    _canModify = value;
    notifyListeners();
  }

  Function(T)? modifySetting<T>(Function(T) func) {
    return canModify ? (value) => func.call(value) : null;
  }
}
