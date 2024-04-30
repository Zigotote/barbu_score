import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/pages/settings/trumps_contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/my_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils.dart';
import '../../utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect(
      $("Paramètres\n${ContractsInfo.trumps.displayName}"),
      findsOneWidget,
    );
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  for (List<ContractsInfo> contractsToDeactivate in [
    [ContractsInfo.barbu],
    [],
    TrumpsContractSettings.availableContracts.sublist(1)
  ]) {
    patrolWidgetTest("should deactivate contracts : $contractsToDeactivate",
        ($) async {
      await $.pumpWidget(_createPage());
      expect(
        _findSwitchs($, true),
        findsNWidgets(TrumpsContractSettings.availableContracts.length + 1),
      );

      for (var contract in contractsToDeactivate) {
        await $.tap(
          find.descendant(of: $(Key(contract.name)), matching: $(Switch)),
        );
      }

      expect(
        _findSwitchs($, false),
        findsNWidgets(contractsToDeactivate.length),
      );
    });
  }
  patrolWidgetTest(
      "should deactivate contract if no active contract inside and block its activation",
      ($) async {
    final nbSwitchs = TrumpsContractSettings.availableContracts.length + 1;

    await $.pumpWidget(_createPage());
    expect(
      $(MySwitch).which((widget) => (widget as MySwitch).isActive),
      findsNWidgets(nbSwitchs),
    );

    await _unplayContracts($);
    expect(_findSwitchs($, false), findsNWidgets(nbSwitchs));

    await $(Switch).first.tap();
    expect(_findSwitchs($, false), findsNWidgets(nbSwitchs));
    expect(($.tester.firstWidget($(Switch)) as Switch).onChanged, isNull);
  });
  patrolWidgetTest(
      "should reenable contract activation after some contracts are reactivated",
      ($) async {
    final nbSwitchs = TrumpsContractSettings.availableContracts.length + 1;

    await $.pumpWidget(_createPage());
    await _unplayContracts($);
    expect(($.tester.firstWidget($(Switch)) as Switch).onChanged, isNull);

    await $(Switch).last.tap();

    expect(_findSwitchs($, false), findsNWidgets(nbSwitchs - 1));
    expect(($.tester.firstWidget($(Switch)) as Switch).onChanged, isNotNull);
  });
}

PatrolFinder _findSwitchs(PatrolTester $, bool value) =>
    $(Switch).which((widget) => (widget as Switch).value == value);

Future<void> _unplayContracts(PatrolTester $) async {
  for (var contract in TrumpsContractSettings.availableContracts) {
    await $.tap(
      find.descendant(of: $(Key(contract.name)), matching: $(Switch)),
    );
  }
}

Widget _createPage() {
  final mockStorage = MockMyStorage2();
  when(mockStorage.getSettings(ContractsInfo.trumps))
      .thenReturn(ContractsInfo.trumps.defaultSettings);

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(
      home: TrumpsContractSettingsPage(),
    ),
  );
}
