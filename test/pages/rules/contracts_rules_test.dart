import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/pages/rules/contracts_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils.mocks.dart';

main() {
  for (var activeContracts in [
    ContractsInfo.values,
    [ContractsInfo.barbu],
    [ContractsInfo.barbu, ContractsInfo.trumps, ContractsInfo.domino]
  ]) {
    patrolWidgetTest(
        "should display contract rules with active $activeContracts",
        ($) async {
      await $.pumpWidget(_createPage(activeContracts));
      expect($("Contrats"), findsOneWidget);

      for (var contract in ContractsInfo.values) {
        expect($(Key(contract.name)), findsOneWidget);
        expect(
          $(Key(contract.name))
              .containing("Ce contrat est désactivé pour vos parties."),
          activeContracts.contains(contract) ? findsNothing : findsOneWidget,
        );
      }
    });
  }
}

Widget _createPage(List<ContractsInfo> activeContracts) {
  final mockStorage = MockMyStorage();
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.defaultSettings;
    contractSettings.isActive = activeContracts.contains(contract);
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: ContractsRules(0)),
  );
}
