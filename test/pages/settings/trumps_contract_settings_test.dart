import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/pages/settings/trumps_contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/my_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';
import 'utils/settings_utils.dart';

main() {
  final contractModel = TrumpsContractModel(
    subContracts: [defaultBarbu],
  );
  final storedGame = createGame(4, [contractModel]);
  final finishedStoredGame = createGame(4, [contractModel])..isFinished = true;

  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres\nSalade"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  group("activate/deactive contract", () {
    for (var validateDeactivate in [true, false]) {
      patrolWidgetTest(
          "should display alert on deactivate contract with stored game and ${validateDeactivate ? "validate" : "cancel"} deactivation",
          ($) async {
        final page = _createPage(storedGame);
        await $.pumpWidgetAndSettle(page);

        _verifyAlert($, storedGame.players);
        await $("Ok").tap();

        // Alert when deactivate contract
        expect(findSwitchValue($), isTrue);
        await $(Switch).first.tap();
        _verifyAlert($, storedGame.players);

        if (validateDeactivate) {
          await $("Désactiver").tap();
          expect(_getContractSettingsProvider(page).isActive, isFalse);
        } else {
          await $("Conserver").tap();
          expect(_getContractSettingsProvider(page).isActive, isTrue);
        }
      });
    }
    for (var game in [null, finishedStoredGame]) {
      patrolWidgetTest("should deactivate contract ${getGameStateText(game)}",
          ($) async {
        await $.pumpWidget(_createPage(game));

        expect(findSwitchValue($), isTrue);

        await $(Switch).first.tap();
        expect(findSwitchValue($), isFalse);
      });
    }
    for (var game in [null, storedGame, finishedStoredGame]) {
      patrolWidgetTest("should activate contract ${getGameStateText(game)}",
          ($) async {
        await $.pumpWidget(_createPage(storedGame, false));
        // Alert dialog is displayed if some players played trumps contract
        if (game?.isFinished == false) {
          await $("Ok").tap();
        }

        expect(findSwitchValue($), isFalse);

        await $(Switch).first.tap();
        expect(findSwitchValue($), isTrue);
      });
    }
  });

  group("add/remove contracts", () {
    for (var game in [null, storedGame, finishedStoredGame]) {
      final gameStateText = getGameStateText(game);
      for (List<ContractsInfo> contractsToDeactivate in [
        [ContractsInfo.barbu],
        [],
        TrumpsContractSettings.availableContracts.sublist(1)
      ]) {
        patrolWidgetTest(
            "should remove contracts from trumps : $contractsToDeactivate $gameStateText",
            ($) async {
          await $.pumpWidget(_createPage(game));
          // Alert dialog is displayed if some players played trumps contract
          if (game?.isFinished == false) {
            await $("Ok").tap();
          }

          expect(
            _findSwitchs($, true),
            findsNWidgets(TrumpsContractSettings.availableContracts.length + 1),
          );

          for (var contract in contractsToDeactivate) {
            await $.tap(
              find.descendant(of: $(Key(contract.name)), matching: $(Switch)),
            );
          }

          expect(
            _findSwitchs($, false),
            findsNWidgets(contractsToDeactivate.length),
          );
        });
      }
      patrolWidgetTest(
          "should deactivate contract if no active contract inside and block its activation $gameStateText",
          ($) async {
        final nbSwitchs = TrumpsContractSettings.availableContracts.length + 1;

        final page = _createPage(game);
        await $.pumpWidget(page);
        // Alert dialog is displayed if some players played trumps contract
        if (game?.isFinished == false) {
          await $("Ok").tap();
        }

        expect(
          $(MySwitch).which((widget) => (widget as MySwitch).isActive),
          findsNWidgets(nbSwitchs),
        );

        await _unplayContracts($);
        expect(_findSwitchs($, false), findsNWidgets(nbSwitchs));

        // Try to activate contract should show an alert and do nothing else
        await $(Switch).first.tap();
        expect($(MyAlertDialog), findsOneWidget);
        await $("Ok").tap();
        expect(_getContractSettingsProvider(page).isActive, isFalse);
      });
      patrolWidgetTest(
          "should reenable contract activation after some contracts are reactivated $gameStateText",
          ($) async {
        final nbSwitchs = TrumpsContractSettings.availableContracts.length + 1;

        await $.pumpWidget(_createPage(game));
        // Alert dialog is displayed if some players played trumps contract
        if (game?.isFinished == false) {
          await $("Ok").tap();
        }

        await _unplayContracts($);
        expect(_findSwitchs($, false), findsNWidgets(nbSwitchs));

        await $(Switch).last.tap();
        expect(_findSwitchs($, false), findsNWidgets(nbSwitchs - 1));

        await $(Switch).first.tap();
        expect($(MyAlertDialog), findsNothing);
        expect(_findSwitchs($, false), findsNWidgets(nbSwitchs - 2));
      });
    }
  });
}

TrumpsContractSettings _getContractSettingsProvider(
    UncontrolledProviderScope page) {
  return getContractSettingsProvider(page, ContractsInfo.trumps);
}

void _verifyAlert(PatrolTester $, List<Player> players) {
  expect($(MyAlertDialog), findsOneWidget);
  for (var player in players) {
    expect(find.textContaining(player.name), findsOneWidget);
  }
}

PatrolFinder _findSwitchs(PatrolTester $, bool value) =>
    $(Switch).which((widget) => (widget as Switch).value == value);

Future<void> _unplayContracts(PatrolTester $) async {
  for (var contract in TrumpsContractSettings.availableContracts) {
    await $.tap(
      find.descendant(of: $(Key(contract.name)), matching: $(Switch)),
    );
  }
}

UncontrolledProviderScope _createPage(
    [Game? storedGame, bool isContractActive = true]) {
  final mockStorage = MockMyStorage();
  when(mockStorage.getSettings(ContractsInfo.trumps)).thenReturn(
    ContractsInfo.trumps.defaultSettings..isActive = isContractActive,
  );
  when(mockStorage.getStoredGame()).thenReturn(storedGame);

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: const TrumpsContractSettingsPage()),
  );
}
