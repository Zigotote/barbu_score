import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/pages/settings/widgets/contract_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils.dart';
import '../../utils.mocks.dart';

const defaultContract = ContractsInfo.barbu;

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres\n${defaultContract.displayName}"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var testData in [
    (hasStoredGame: true, deleteStoredGame: true),
    (hasStoredGame: true, deleteStoredGame: false),
    (hasStoredGame: false, deleteStoredGame: null)
  ]) {
    final hasStoredGame = testData.hasStoredGame;
    final allowModification = testData.deleteStoredGame != false;
    patrolWidgetTest(
      "should ${hasStoredGame ? "" : "not "}alert user before modifications if ${hasStoredGame ? "" : "no "}stored game and ${allowModification ? "allow" : "disallow"} modifications",
      ($) async {
        await $.pumpWidgetAndSettle(_createPage(hasStoredGame));

        final alertTitle = $("Modification des paramètres");
        if (hasStoredGame) {
          expect(alertTitle, findsOneWidget);
          if (allowModification) {
            await $("Supprimer").tap();
          } else {
            await $("Consulter").tap();
          }
        }

        expect(alertTitle, findsNothing);

        expect(($.tester.firstWidget($(Switch)) as Switch).onChanged,
            allowModification ? isNotNull : isNull);
      },
    );
  }
}

Widget _createPage([bool hasStoredGame = false]) {
  final mockStorage = MockMyStorage2();
  when(mockStorage.hasStoredGame()).thenReturn(hasStoredGame);
  when(mockStorage.getSettings(defaultContract))
      .thenReturn(defaultContract.defaultSettings);

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(
      home: ContractSettingsPage(contract: defaultContract, children: []),
    ),
  );
}
