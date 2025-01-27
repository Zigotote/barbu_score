import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/pages/settings/widgets/contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/my_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

main() {
  group("#_alertChangeIsActive", () {
    for (var hasContracts in [true, false]) {
      patrolWidgetTest("should show alert if trumps contract has no contracts",
          ($) async {
        final mockStorage = MockMyStorage();
        const contract = ContractsInfo.trumps;
        final settings = TrumpsContractSettings(
          isActive: true,
          contracts: {
            for (var contract in TrumpsContractSettings.availableContracts)
              contract.name: hasContracts
          },
        );
        when(mockStorage.getSettings(contract)).thenReturn(settings);

        await $.pumpWidgetAndSettle(
          _createPage(contract: contract, mockStorage: mockStorage),
        );
        await $.tap($(MySwitch));

        if (hasContracts) {
          expect($(MyAlertDialog), findsNothing);
        } else {
          expect($(MyAlertDialog), findsOneWidget);
          expect($("Ok"), findsOneWidget);
        }
      });
    }
    for (var testData in [
      (isGameFinished: true, isActive: true, hasBeenPlayed: true),
      (isGameFinished: false, isActive: true, hasBeenPlayed: true),
      (isGameFinished: false, isActive: true, hasBeenPlayed: false),
      (isGameFinished: false, isActive: false, hasBeenPlayed: true),
      (isGameFinished: false, isActive: false, hasBeenPlayed: false)
    ]) {
      final shouldHaveAlert = testData.isActive &&
          testData.hasBeenPlayed &&
          !testData.isGameFinished;
      patrolWidgetTest(
          "should${shouldHaveAlert ? "" : " not"} show alert if game is ${testData.isGameFinished ? "" : "not "}finished, contract is${testData.isActive ? "" : " not"} active and has${testData.hasBeenPlayed ? "" : " not"} been played by player",
          ($) async {
        final mockStorage = MockMyStorage();
        const contract = ContractsInfo.barbu;
        final settings = contract.defaultSettings.copy()
          ..isActive = testData.isActive;
        final game = createGame(
          4,
          testData.hasBeenPlayed ? [defaultBarbu] : [],
        )..isFinished = testData.isGameFinished;
        when(mockStorage.getSettings(contract)).thenReturn(settings);
        when(mockStorage.getStoredGame()).thenReturn(game);

        await $.pumpWidgetAndSettle(
          _createPage(contract: contract, mockStorage: mockStorage),
        );
        await $.tap($(MySwitch));

        if (shouldHaveAlert) {
          expect($(MyAlertDialog), findsOneWidget);
          expect($(ElevatedButtonCustomColor), findsNWidgets(2));
        } else {
          expect($(MyAlertDialog), findsNothing);
        }
      });
    }
  });
}

UncontrolledProviderScope _createPage(
    {required ContractsInfo contract, required MyStorage mockStorage}) {
  final container = ProviderContainer(
    overrides: [storageProvider.overrideWithValue(mockStorage)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(
      home: ContractSettingsPage(contract: contract, children: const []),
    ),
  );
}
