import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/pages/settings/domino_contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/number_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.mocks.dart';

final _defaultSettings =
    ContractsInfo.domino.defaultSettings as DominoContractSettings;

void main() {
  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres"), findsOneWidget);
    expect($("Réussite"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    // await checkAccessibility($.tester); not accessible because Switches are considered not accessible, but screen reader is correct
  });

  patrolWidgetTest("should change points", ($) async {
    const changedPoints = 5;
    final expectedDominoPoints =
        Map<int, List<int>>.from(_defaultSettings.points);
    expectedDominoPoints[kNbPlayersMin]![0] = changedPoints;
    final newSettings = _defaultSettings.copyWith(points: expectedDominoPoints);
    final mockStorage = MockMyStorage();

    final page = _createPage(mockStorage);
    await $.pumpWidget(page);

    await $(NumberInput).enterText("$changedPoints");
    verify(mockStorage.saveSettings(ContractsInfo.domino, newSettings));
  });
}

UncontrolledProviderScope _createPage([MockMyStorage? mockStorage]) {
  mockStorage ??= MockMyStorage();
  when(mockStorage.getSettings(ContractsInfo.domino))
      .thenReturn(_defaultSettings);

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: const DominoContractSettingsPage()),
  );
}
