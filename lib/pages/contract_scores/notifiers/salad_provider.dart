import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../../commons/models/contract_models.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/providers/contracts_manager.dart';

final saladProvider = ChangeNotifierProvider.autoDispose<SaladNotifier>(
  (ref) => SaladNotifier(
    ref.read(contractsManagerProvider).getContractManager(ContractsInfo.salad),
  ),
);

class SaladNotifier with ChangeNotifier {
  final SaladContractModel model;
  final SaladContractSettings _settings;

  SaladNotifier(ContractManager manager)
    : model = manager.model as SaladContractModel,
      _settings = manager.settings as SaladContractSettings;

  bool get isValid =>
      _settings.activeContracts.length == model.subContracts.length;

  List<ContractsInfo> get subContracts => _settings.activeContracts;

  /// Returns the filled contract which matches the contractName. If there is none, returns null
  ContractWithPointsModel? getFilledContract(String contractName) {
    return model.subContracts.firstWhereOrNull(
      (contract) => contract.name == contractName,
    );
  }

  /// Adds a contract to the filledContracts list
  void addContract(ContractWithPointsModel contract) {
    model.addSubContract(contract);
    notifyListeners();
  }
}
