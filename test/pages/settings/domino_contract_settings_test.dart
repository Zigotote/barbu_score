import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/globals.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/pages/settings/domino_contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils.dart';
import '../../utils.mocks.dart';
import 'utils/settings_utils.dart';

main() {
  final contractModel = DominoContractModel(
    rankOfPlayer: {
      for (var (index, player) in defaultPlayerNames.indexed) player: index
    },
  );
  final storedGame = createGame(4, [contractModel]);
  final finishedStoredGame = createGame(4, [contractModel])..isFinished = true;

  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect(
        $("Paramètres\n${ContractsInfo.domino.displayName}"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  for (var game in [null, storedGame, finishedStoredGame]) {
    patrolWidgetTest("should change points ${getGameStateText(game)}",
        ($) async {
      const newPoints = 5;

      final page = _createPage();
      await $.pumpWidget(page);

      await $(NumberInput).enterText("$newPoints");
      expect(
        _getContractSettingsProvider(page).points[kNbPlayersMin]![0],
        newPoints,
      );
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

DominoContractSettings _getContractSettingsProvider(
    UncontrolledProviderScope page) {
  return getContractSettingsProvider(page, ContractsInfo.domino);
}

UncontrolledProviderScope _createPage([Game? storedGame]) {
  final mockStorage = MockMyStorage();
  when(mockStorage.getStoredGame()).thenReturn(storedGame);
  when(mockStorage.getSettings(ContractsInfo.domino))
      .thenReturn(ContractsInfo.domino.defaultSettings);

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(
      home: DominoContractSettingsPage(),
    ),
  );
}
