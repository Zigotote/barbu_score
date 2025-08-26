import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/pages/settings/widgets/change_contract_activation.dart';
import 'package:barbu_score/pages/settings/widgets/my_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../utils/french_material_app.dart';
import '../../../utils/utils.dart';
import '../../../utils/utils.mocks.dart';

void main() {
  patrolWidgetTest(
      "should not show alert if salad contract has no contracts and activate",
      ($) async {
    final mockStorage = MockMyStorage();
    const contract = ContractsInfo.salad;
    final settings = contract.defaultSettings.copyWith(isActive: false);

    await $.pumpWidgetAndSettle(
      _createPage(
        contract: contract,
        settings: settings,
        mockStorage: mockStorage,
      ),
    );
    await $.tap($(MySwitch));

    expect($(MyAlertDialog), findsNothing);
    verify(
      mockStorage.saveSettings(contract, settings.copyWith(isActive: true)),
    );
  });
  patrolWidgetTest(
      "should show alert if salad contract has no contracts and activate",
      ($) async {
    final mockStorage = MockMyStorage();
    const contract = ContractsInfo.salad;
    final settings = SaladContractSettings(
      isActive: false,
      contracts: {
        for (var contract in SaladContractSettings.availableContracts)
          contract.name: false
      },
    );

    await $.pumpWidgetAndSettle(
      _createPage(
        contract: contract,
        settings: settings,
        mockStorage: mockStorage,
      ),
    );
    await $.tap($(MySwitch));

    expect($(MyAlertDialog), findsOneWidget);
    await $("OK").tap();
    verifyNever(mockStorage.saveSettings(contract, any));
  });
  for (var testData in [
    (isGameFinished: true, isActive: true, hasBeenPlayed: true),
    (isGameFinished: false, isActive: true, hasBeenPlayed: false),
    (isGameFinished: false, isActive: false, hasBeenPlayed: true),
    (isGameFinished: false, isActive: false, hasBeenPlayed: false)
  ]) {
    patrolWidgetTest(
        "should toggle activation and not show alert on ${testData.isActive ? 'deactivate' : 'activate'} if game is ${testData.isGameFinished ? "" : "not "}finished and contract has${testData.hasBeenPlayed ? "" : " not"} been played by player",
        ($) async {
      final mockStorage = MockMyStorage();
      const contract = ContractsInfo.barbu;
      final settings =
          contract.defaultSettings.copyWith(isActive: testData.isActive);
      final game = createGame(
        4,
        testData.hasBeenPlayed ? [defaultBarbu] : [],
      )..isFinished = testData.isGameFinished;
      when(mockStorage.getStoredGame()).thenReturn(game);

      await $.pumpWidgetAndSettle(
        _createPage(
          contract: contract,
          settings: settings,
          mockStorage: mockStorage,
        ),
      );
      await $.tap($(MySwitch));

      expect($(MyAlertDialog), findsNothing);
      verify(
        mockStorage.saveSettings(
          contract,
          settings.copyWith(isActive: !testData.isActive),
        ),
      );
    });
  }
  for (var validateDeactivate in [true, false]) {
    patrolWidgetTest(
        "should ${validateDeactivate ? "" : "not "}validate deactivate when contract has been played",
        ($) async {
      final mockStorage = MockMyStorage();
      const contract = ContractsInfo.barbu;
      final settings = contract.defaultSettings;
      final game = createGame(4, [defaultBarbu]);
      when(mockStorage.getStoredGame()).thenReturn(game);

      await $.pumpWidgetAndSettle(
        _createPage(
          contract: contract,
          settings: settings,
          mockStorage: mockStorage,
        ),
      );
      await $.tap($(MySwitch));

      expect($(MyAlertDialog), findsOneWidget);
      if (validateDeactivate) {
        await $("Désactiver").tap();
        verify(
          mockStorage.saveSettings(
            contract,
            settings.copyWith(isActive: false),
          ),
        );
      } else {
        await $("Conserver").tap();
        verifyNever(mockStorage.saveSettings(contract, any));
      }
    });
  }
}

UncontrolledProviderScope _createPage(
    {required ContractsInfo contract,
    required AbstractContractSettings settings,
    required MyStorage mockStorage}) {
  when(mockStorage.getSettings(contract)).thenReturn(settings);
  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(
      home: Scaffold(body: ChangeContractActivation(contract, settings)),
    ),
  );
}
