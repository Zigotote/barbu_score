import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/rules/contracts_rules.dart';
import 'package:barbu_score/pages/rules/widgets/settings_card.dart';
import 'package:barbu_score/pages/settings/my_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.mocks.dart';

main() {
  for (var activeContracts in [
    ContractsInfo.values,
    [ContractsInfo.barbu],
    [ContractsInfo.barbu, ContractsInfo.salad, ContractsInfo.domino]
  ]) {
    patrolWidgetTest(
        "should display contract rules with active $activeContracts",
        ($) async {
      await $.pumpWidget(_createPage(activeContracts));
      expect($("Contrats"), findsOneWidget);

      for (var contract in ContractsInfo.values) {
        expect($(Key(contract.name)), findsOneWidget);
        expect(
          $(Key(contract.name)).containing("Désactivé pour vos parties."),
          activeContracts.contains(contract) ? findsNothing : findsOneWidget,
        );
      }
    });
  }
  patrolWidgetTest("should go to settings page", ($) async {
    await $.pumpWidget(_createPage());

    await $.scrollUntilVisible(finder: $(SettingsCard));
    await $(OutlinedButton).tap();

    expect($(MySettings), findsOneWidget);
  });
}

Widget _createPage([List<ContractsInfo>? activeContracts]) {
  final mockStorage = MockMyStorage();
  for (var contract in ContractsInfo.values) {
    final contractSettings = contract.defaultSettings;
    contractSettings.isActive = activeContracts?.contains(contract) ?? false;
    when(mockStorage.getSettings(contract)).thenReturn(contractSettings);
  }
  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(
      home: const ContractsRules(0),
      routes: {Routes.settings: (_) => const MySettings()},
    ),
  );
}
