import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commons/models/contract_info.dart';
import '../../../../commons/models/contract_models.dart';

final trumpsProvider = ChangeNotifierProvider.autoDispose<TrumpsNotifier>(
  (ref) => TrumpsNotifier(),
);

class TrumpsNotifier with ChangeNotifier {
  /// The contracts the player has filled
  final List<AbstractContractModel> _filledContracts = [];

  ///  The list of contracts to fill for a trump contract
  final List<ContractsInfo> trumpContracts = ContractsInfo.values
      .where((contractInfo) =>
          contractInfo != ContractsInfo.trumps &&
          contractInfo != ContractsInfo.domino)
      .toList();

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
