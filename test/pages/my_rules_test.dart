import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/pages/my_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils.dart';
import '../utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Règles du jeu"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
}

Widget _createPage() {
  final mockStorage = MockMyStorage2();
  mockActiveContracts(mockStorage);

  final container = ProviderContainer(
    overrides: [
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: MyRules()),
  );
}
