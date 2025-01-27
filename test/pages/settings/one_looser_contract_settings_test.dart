import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/pages/settings/one_looser_contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';
import 'utils/settings_utils.dart';

const _defaultContract = ContractsInfo.barbu;

main() {
  final storedGame = createGame(4, [defaultBarbu]);
  final finishedStoredGame = createGame(4, [defaultBarbu])..isFinished = true;

  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres\nBarbu"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  for (var game in [null, storedGame, finishedStoredGame]) {
    patrolWidgetTest("should change points ${getGameStateText(game)}",
        ($) async {
      final defaultPoints =
          (_defaultContract.defaultSettings as OneLooserContractSettings)
              .points;
      final newPoints = defaultPoints + 10;

      final page = _createPage();
      await $.pumpWidget(page);

      expect($("$defaultPoints"), findsOneWidget);

      await $(NumberInput).enterText("$newPoints");
      expect(_getContractSettingsProvider(page).points, newPoints);
    });
  }
  for (var game in [null, finishedStoredGame]) {
    patrolWidgetTest(
        "should change contract activation with ${getGameStateText(game)}",
        ($) async {
      final page = _createPage(game);
      await $.pumpWidget(page);

      expect(findSwitchValue($), isTrue);

      await $(Switch).tap();
      expect(_getContractSettingsProvider(page).isActive, isFalse);
    });
  }
  for (var validateDeactivate in [true, false]) {
    patrolWidgetTest(
        "should ${validateDeactivate ? "change" : "cancel"} contract activation with stored game",
        ($) async {
      final page = _createPage(storedGame);
      await $.pumpWidget(page);

      expect(findSwitchValue($), isTrue);

      await $(Switch).tap();

      expect($(MyAlertDialog), findsOneWidget);
      if (validateDeactivate) {
        await $("Désactiver").tap();
        expect(_getContractSettingsProvider(page).isActive, isFalse);
      } else {
        await $("Conserver").tap();
        expect(_getContractSettingsProvider(page).isActive, isTrue);
      }
    });
  }
}

OneLooserContractSettings _getContractSettingsProvider(
    UncontrolledProviderScope page) {
  return getContractSettingsProvider(page, _defaultContract);
}

UncontrolledProviderScope _createPage([Game? storedGame]) {
  final mockStorage = MockMyStorage();
  when(mockStorage.getStoredGame()).thenReturn(storedGame);
  when(mockStorage.getSettings(_defaultContract))
      .thenReturn(_defaultContract.defaultSettings);

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
