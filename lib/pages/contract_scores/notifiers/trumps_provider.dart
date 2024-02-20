import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../../commons/models/contract_models.dart';
import '../../../commons/models/contract_settings_models.dart';
import '../../../commons/utils/storage.dart';

final trumpsProvider = ChangeNotifierProvider.autoDispose<TrumpsNotifier>(
  (ref) {
    final Map<ContractsInfo, bool> activeContracts = Map.from(
        MyStorage.getSettings<TrumpsContractSettings>(ContractsInfo.trumps)
            .contracts)
      ..removeWhere((_, isActive) => !isActive);
    return TrumpsNotifier(activeContracts.keys.toList());
  },
);

class TrumpsNotifier with ChangeNotifier {
  /// The contracts the player has filled
  final List<AbstractContractModel> _filledContracts = [];

  ///  The list of contracts to fill for a trump contract
  final List<ContractsInfo> trumpContracts;

  TrumpsNotifier(this.trumpContracts);

  /// Returns true if the contract is entirely filled
  bool get isValid => _filledContracts.length == trumpContracts.length;

  /// Returns the players scores
  Map<String, int> get playerScores =>
      AbstractContractModel.calculateTotalScore(_filledContracts);

  /// Returns the filled contract which matches the contractName. If there is none, returns null
  AbstractContractModel? getFilledContract(String contractName) {
    return _filledContracts
        .firstWhereOrNull((contract) => contract.name == contractName);
  }

  /// Adds a contract to the filledContracts list
  bool addContract(ContractsInfo contractInfo, Map<String, int> playerItems) {
    AbstractContractModel contract = contractInfo.contract;
    bool isValid = contract.setScores(playerItems);
    if (isValid) {
      _filledContracts
          .removeWhere((contract) => contract.name == contractInfo.name);
      _filledContracts.add(contract);
    }
    notifyListeners();
    return isValid;
  }
}
