import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/models/game_settings.dart';
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

final _defaultSettings =
    ContractsInfo.salad.defaultSettings as SaladContractSettings;

void main() {
  patrolWidgetTest("should display page", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres"), findsOneWidget);
    expect($("Salade"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    // await checkAccessibility($.tester); not accessible because Switches are considered not accessible, but screen reader is correct
  });

  patrolWidgetTest("should show alert if contract has been played", ($) async {
    final mockStorage = MockMyStorage();
    final game = createGame(4, [
      SaladContractModel(subContracts: [defaultBarbu]),
    ]);
    when(mockStorage.getStoredGame()).thenReturn(game);

    final page = _createPage(mockStorage);
    await $.pumpWidgetAndSettle(page);

    expect($(MyAlertDialog), findsOneWidget);
    for (var player in game.players) {
      expect(find.textContaining(player.name), findsOneWidget);
    }

    await $("OK").tap();
    expect($(MyAlertDialog), findsNothing);
  });

  patrolWidgetTest("should change invert scores", ($) async {
    final mockStorage = MockMyStorage();
    final page = _createPage(mockStorage);
    await $.pumpWidget(page);

    final invertScoreSwitchIndex =
        SaladContractSettings.availableContracts.length + 1;
    expect(findSwitchValue($, index: invertScoreSwitchIndex), isFalse);

    await $(Switch).at(invertScoreSwitchIndex).tap();
    verify(
      mockStorage.saveSettings(
        ContractsInfo.salad,
        _defaultSettings.copyWith(invertScore: true),
      ),
    );
  });

  group("add/remove contracts", () {
    for (List<ContractsInfo> contractsToDeactivate in [
      [ContractsInfo.barbu],
      SaladContractSettings.availableContracts.sublist(1),
    ]) {
      patrolWidgetTest(
        "should remove contracts from salad : $contractsToDeactivate",
        ($) async {
          final mockStorage = MockMyStorage();
          await $.pumpWidget(_createPage(mockStorage));

          expect(
            _findSwitches($, true),
            findsNWidgets(SaladContractSettings.availableContracts.length + 1),
          );
          expect(_findSwitches($, false), findsOneWidget); // Invert score

          for (var contract in contractsToDeactivate) {
            await $.tap(
              find.descendant(of: $(Key(contract.name)), matching: $(Switch)),
            );
          }

          expect(
            _findSwitches($, false),
            findsNWidgets(contractsToDeactivate.length + 1),
          );
          verify(
            mockStorage.saveSettings(
              ContractsInfo.salad,
              _defaultSettings.copyWith(
                contracts: {
                  for (var contract in SaladContractSettings.availableContracts)
                    contract.name: !contractsToDeactivate.contains(contract),
                },
              ),
            ),
          );
        },
      );
    }
    patrolWidgetTest(
      "should deactivate contract if no active contract inside and block its activation",
      ($) async {
        final nbSwitches = SaladContractSettings.availableContracts.length + 1;
        final mockStorage = MockMyStorage();

        final page = _createPage(mockStorage);
        await $.pumpWidget(page);

        expect(
          $(MySwitch).which((widget) => (widget as MySwitch).isActive),
          findsNWidgets(nbSwitches),
        );

        await _removeContracts($);
        expect(_findSwitches($, false), findsNWidgets(nbSwitches + 1));
        verify(
          mockStorage.saveSettings(
            ContractsInfo.salad,
            _defaultSettings.copyWith(
              isActive: false,
              contracts: {
                for (var contract in SaladContractSettings.availableContracts)
                  contract.name: false,
              },
            ),
          ),
        );

        // Try to activate contract should show an alert and do nothing else
        await $(Switch).first.tap();
        expect($(MyAlertDialog), findsOneWidget);
        await $("OK").tap();
        verifyNever(
          mockStorage.saveSettings(
            ContractsInfo.salad,
            _defaultSettings.copyWith(
              isActive: true,
              contracts: {
                for (var contract in SaladContractSettings.availableContracts)
                  contract.name: false,
              },
            ),
          ),
        );
      },
    );
    patrolWidgetTest(
      "should reenable contract activation after some contracts are reactivated",
      ($) async {
        final nbSwitchs = SaladContractSettings.availableContracts.length + 2;

        await $.pumpWidget(_createPage());

        await _removeContracts($);
        expect(_findSwitches($, false), findsNWidgets(nbSwitchs));

        await $(Switch).at(2).tap();
        expect(_findSwitches($, false), findsNWidgets(nbSwitchs - 1));

        await $(Switch).first.tap();
        expect($(MyAlertDialog), findsNothing);
        expect(_findSwitches($, false), findsNWidgets(nbSwitchs - 2));
      },
    );
  });
}

PatrolFinder _findSwitches(PatrolTester $, bool value) =>
    $(Switch).which((widget) => (widget as Switch).value == value);

Future<void> _removeContracts(PatrolTester $) async {
  for (var contract in SaladContractSettings.availableContracts) {
    await $.tap(
      find.descendant(of: $(Key(contract.name)), matching: $(Switch)),
    );
  }
}

UncontrolledProviderScope _createPage([
  MockMyStorage? mockStorage,
  bool isContractActive = true,
]) {
  mockStorage ??= MockMyStorage();
  when(mockStorage.getGameSettings()).thenReturn(GameSettings());
  when(
    mockStorage.getSettings(ContractsInfo.salad),
  ).thenReturn(_defaultSettings.copyWith(isActive: isContractActive));

  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: const SaladContractSettingsPage()),
  );
}
