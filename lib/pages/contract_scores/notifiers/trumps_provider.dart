import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../../commons/models/contract_models.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/providers/contracts_manager.dart';

final trumpsProvider = ChangeNotifierProvider.autoDispose<TrumpsNotifier>(
  (ref) => TrumpsNotifier(
    ref.read(contractsManagerProvider).getContractManager(ContractsInfo.trumps),
  ),
);

class TrumpsNotifier with ChangeNotifier {
  final TrumpsContractModel model;
  final TrumpsContractSettings _settings;

  TrumpsNotifier(ContractManager manager)
      : model = manager.model as TrumpsContractModel,
        _settings = manager.settings as TrumpsContractSettings;

  bool get isValid =>
      _settings.activeContracts.length == model.subContracts.length;

  List<ContractsInfo> get subContracts => _settings.activeContracts;

  /// Returns the filled contract which matches the contractName. If there is none, returns null
  AbstractSubContractModel? getFilledContract(String contractName) {
    return model.subContracts
        .firstWhereOrNull((contract) => contract.name == contractName);
  }

  /// Adds a contract to the filledContracts list
  void addContract(AbstractSubContractModel contract) {
    model.addSubContract(contract);
    notifyListeners();
  }
}
