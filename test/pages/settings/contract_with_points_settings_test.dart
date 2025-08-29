import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/pages/settings/contract_with_points_settings.dart';
import 'package:barbu_score/pages/settings/widgets/my_switch.dart';
import 'package:barbu_score/pages/settings/widgets/number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.mocks.dart';
import 'utils/settings_utils.dart';

const _defaultContract = ContractsInfo.noHearts;

void main() {
  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres"), findsOneWidget);
    expect($("Sans coeurs"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    // await checkAccessibility($.tester); not accessible because Switches are considered not accessible, but screen reader is correct
  });

  for (var contract in [
    ContractsInfo.barbu,
    ContractsInfo.noHearts,
    ContractsInfo.noQueens,
    ContractsInfo.noTricks,
    ContractsInfo.noLastTrick
  ]) {
    final shouldHaveInvertScore = contract != ContractsInfo.barbu &&
        contract != ContractsInfo.noLastTrick;
    patrolWidgetTest(
        "should ${shouldHaveInvertScore ? "" : "not "}display invert scores for $contract",
        ($) async {
      final page = _createPage(contract: contract);
      await $.pumpWidget(page);

      expect(
        $(MySwitch),
        shouldHaveInvertScore ? findsNWidgets(2) : findsOneWidget,
      );
      expect(
        $("Inversion du score"),
        shouldHaveInvertScore ? findsOneWidget : findsNothing,
      );
    });
  }

  patrolWidgetTest("should change points", ($) async {
    final mockStorage = MockMyStorage();
    final newPoints = -666;
    final defaultSettings =
        _defaultContract.defaultSettings as ContractWithPointsSettings;

    final page = _createPage(mockStorage: mockStorage);
    await $.pumpWidget(page);

    expect($("${defaultSettings.points}"), findsOneWidget);

    await $(NumberInput).enterText("$newPoints");
    verify(
      mockStorage.saveSettings(
        _defaultContract,
        defaultSettings.copyWith(points: newPoints),
      ),
    );
  });
  patrolWidgetTest("should change invert scores", ($) async {
    final mockStorage = MockMyStorage();

    final page = _createPage(mockStorage: mockStorage);
    await $.pumpWidget(page);

    expect(findSwitchValue($, index: 1), isTrue);

    await $(Switch).at(1).tap();
    verify(
      mockStorage.saveSettings(
        _defaultContract,
        (_defaultContract.defaultSettings as ContractWithPointsSettings)
            .copyWith(invertScore: false),
      ),
    );
  });
}

UncontrolledProviderScope _createPage(
    {MockMyStorage? mockStorage, ContractsInfo contract = _defaultContract}) {
  mockStorage ??= MockMyStorage();
  when(mockStorage.getSettings(contract)).thenReturn(contract.defaultSettings);

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: ContractWithPointsSettingsPage(contract)),
  );
}
