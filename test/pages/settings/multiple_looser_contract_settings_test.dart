import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/pages/settings/multiple_looser_contract_settings.dart';
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

const _defaultContract = ContractsInfo.noHearts;

main() {
  final contractModel = MultipleLooserContractModel(
    contract: _defaultContract,
    nbItems: 4,
    itemsByPlayer: {for (var player in defaultPlayerNames) player: 1},
  );
  final storedGame = createGame(4, [contractModel]);
  final finishedStoredGame = createGame(4, [contractModel])..isFinished = true;

  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres\nSans coeurs"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    // await checkAccessibility($.tester); not accessible because Switches are considered not accessible, but screen reader is correct
  });

  for (var game in [null, storedGame, finishedStoredGame]) {
    patrolWidgetTest("should change points ${getGameStateText(game)}",
        ($) async {
      final defaultPoints =
          (_defaultContract.defaultSettings as MultipleLooserContractSettings)
              .points;
      final newPoints = defaultPoints + 10;

      final page = _createPage();
      await $.pumpWidget(page);

      expect($("$defaultPoints"), findsOneWidget);

      await $(NumberInput).enterText("$newPoints");
      expect(_getContractSettingsProvider(page).points, newPoints);
    });
    patrolWidgetTest("should change invert scores ${getGameStateText(game)}",
        ($) async {
      final page = _createPage();
      await $.pumpWidget(page);

      expect(findSwitchValue($, index: 1), isTrue);

      await $(Switch).at(1).tap();
      expect(_getContractSettingsProvider(page).invertScore, isFalse);
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

MultipleLooserContractSettings _getContractSettingsProvider(
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
      home: const MultipleLooserContractSettingsPage(_defaultContract),
    ),
  );
}
