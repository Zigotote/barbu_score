import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/pages/rules/my_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Règles du jeu"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  // Cannot write other tests because all widgets are stacked in TurnPageView
  // which makes tapping and verifying widgets very hard
}

Widget _createPage() {
  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage);

  final container = ProviderContainer(
    overrides: [
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: const MyRules()),
  );
}
