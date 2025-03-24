import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/pages/settings/salad_contract_settings.dart';
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
  final contractModel = SaladContractModel(subContracts: [defaultBarbu]);
  final storedGame = createGame(4, [contractModel]);
  final finishedStoredGame = createGame(4, [contractModel])..isFinished = true;

  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres\nSalade"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  for (var game in [null, storedGame, finishedStoredGame]) {
    patrolWidgetTest("should change invert scores ${getGameStateText(game)}",
        ($) async {
      final page = _createPage(game);
      await $.pumpWidget(page);

      final invertScoreSwitchIndex =
          SaladContractSettings.availableContracts.length + 1;
      expect(findSwitchValue($, index: invertScoreSwitchIndex), isFalse);

      await $(Switch).at(invertScoreSwitchIndex).tap();
      expect(_getContractSettingsProvider(page).invertScore, isTrue);
    });
  }

  group("activate/deactive contract", () {
    for (var validateDeactivate in [true, false]) {
      patrolWidgetTest(
          "should display alert on deactivate contract with stored game and ${validateDeactivate ? "validate" : "cancel"} deactivation",
          ($) async {
        final page = _createPage(storedGame);
        await $.pumpWidgetAndSettle(page);

        _verifyAlert($, storedGame.players);
        await $("OK").tap();

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
        // Alert dialog is displayed if some players played salad contract
        if (game?.isFinished == false) {
          await $("OK").tap();
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
        SaladContractSettings.availableContracts.sublist(1)
      ]) {
        patrolWidgetTest(
            "should remove contracts from salad : $contractsToDeactivate $gameStateText",
            ($) async {
          await $.pumpWidget(_createPage(game));
          // Alert dialog is displayed if some players played salad contract
          if (game?.isFinished == false) {
            await $("OK").tap();
          }

          expect(
            _findSwitchs($, true),
            findsNWidgets(SaladContractSettings.availableContracts.length + 1),
          );
          expect(_findSwitchs($, false), findsOneWidget); // Invert score

          for (var contract in contractsToDeactivate) {
            await $.tap(
              find.descendant(of: $(Key(contract.name)), matching: $(Switch)),
            );
          }

          expect(
            _findSwitchs($, false),
            findsNWidgets(contractsToDeactivate.length + 1),
          );
        });
      }
      patrolWidgetTest(
          "should deactivate contract if no active contract inside and block its activation $gameStateText",
          ($) async {
        final nbSwitches = SaladContractSettings.availableContracts.length + 1;

        final page = _createPage(game);
        await $.pumpWidget(page);
        // Alert dialog is displayed if some players played salad contract
        if (game?.isFinished == false) {
          await $("OK").tap();
        }

        expect(
          $(MySwitch).which((widget) => (widget as MySwitch).isActive),
          findsNWidgets(nbSwitches),
        );

        await removeContracts($);
        expect(_findSwitchs($, false), findsNWidgets(nbSwitches + 1));

        // Try to activate contract should show an alert and do nothing else
        await $(Switch).first.tap();
        expect($(MyAlertDialog), findsOneWidget);
        await $("OK").tap();
        expect(_getContractSettingsProvider(page).isActive, isFalse);
      });
      patrolWidgetTest(
          "should reenable contract activation after some contracts are reactivated $gameStateText",
          ($) async {
        final nbSwitchs = SaladContractSettings.availableContracts.length + 2;

        await $.pumpWidget(_createPage(game));
        // Alert dialog is displayed if some players played salad contract
        if (game?.isFinished == false) {
          await $("OK").tap();
        }

        await removeContracts($);
        expect(_findSwitchs($, false), findsNWidgets(nbSwitchs));

        await $(Switch).at(2).tap();
        expect(_findSwitchs($, false), findsNWidgets(nbSwitchs - 1));

        await $(Switch).first.tap();
        expect($(MyAlertDialog), findsNothing);
        expect(_findSwitchs($, false), findsNWidgets(nbSwitchs - 2));
      });
    }
  });
}

SaladContractSettings _getContractSettingsProvider(
    UncontrolledProviderScope page) {
  return getContractSettingsProvider(page, ContractsInfo.salad);
}

void _verifyAlert(PatrolTester $, List<Player> players) {
  expect($(MyAlertDialog), findsOneWidget);
  for (var player in players) {
    expect(find.textContaining(player.name), findsOneWidget);
  }
}

PatrolFinder _findSwitchs(PatrolTester $, bool value) =>
    $(Switch).which((widget) => (widget as Switch).value == value);

Future<void> removeContracts(PatrolTester $) async {
  for (var contract in SaladContractSettings.availableContracts) {
    await $.tap(
      find.descendant(of: $(Key(contract.name)), matching: $(Switch)),
    );
  }
}

UncontrolledProviderScope _createPage(
    [Game? storedGame, bool isContractActive = true]) {
  final mockStorage = MockMyStorage();
  when(mockStorage.getSettings(ContractsInfo.salad)).thenReturn(
    ContractsInfo.salad.defaultSettings..isActive = isContractActive,
  );
  when(mockStorage.getStoredGame()).thenReturn(storedGame);

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: const SaladContractSettingsPage()),
  );
}
