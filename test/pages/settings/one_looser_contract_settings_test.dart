import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/pages/settings/one_looser_contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/number_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.mocks.dart';

const _defaultContract = ContractsInfo.barbu;
final _defaultSettings =
    _defaultContract.defaultSettings as OneLooserContractSettings;

void main() {
  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres"), findsOneWidget);
    expect($("Barbu"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    // await checkAccessibility($.tester); not accessible because Switches are considered not accessible, but screen reader is correct
  });

  patrolWidgetTest("should change points", ($) async {
    final newPoints = -666;
    final mockStorage = MockMyStorage();

    final page = _createPage(mockStorage);
    await $.pumpWidget(page);

    expect($("${_defaultSettings.points}"), findsOneWidget);

    await $(NumberInput).enterText("$newPoints");
    verify(
      mockStorage.saveSettings(
        _defaultContract,
        _defaultSettings.copyWith(points: newPoints),
      ),
    );
  });
}

UncontrolledProviderScope _createPage([MockMyStorage? mockStorage]) {
  mockStorage ??= MockMyStorage();
  when(mockStorage.getSettings(_defaultContract)).thenReturn(_defaultSettings);

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(
      home: const OneLooserContractSettingsPage(_defaultContract),
    ),
  );
}
