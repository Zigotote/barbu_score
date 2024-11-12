import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/pages/settings/notifiers/contract_settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils.dart';
import '../../../utils.mocks.dart';

main() {
  group("#alertChangeIsActive", () {
    for (var hasContracts in [true, false]) {
      test("should return alert if trumps contract has no contracts", () {
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

        final contractNotifier =
            ContractSettingsNotifier(mockStorage, contract: contract);

        final alert = contractNotifier.alertChangeIsActive(MockBuildContext());

        if (hasContracts) {
          expect(alert, isNull);
        } else {
          expect(alert, isA<MyAlertDialog>());
          expect(alert?.actions?.length, 1);
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
      test(
          "should${shouldHaveAlert ? "" : " not"} return alert if game is ${testData.isGameFinished ? "" : "not "}finished, contract is${testData.isActive ? "" : " not"} active and has${testData.hasBeenPlayed ? "" : " not"} been played by player",
          () {
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

        final contractNotifier =
            ContractSettingsNotifier(mockStorage, contract: contract);

        final alert = contractNotifier.alertChangeIsActive(MockBuildContext());

        if (shouldHaveAlert) {
          expect(alert, isA<MyAlertDialog>());
          expect(alert?.actions?.length, 2);
        } else {
          expect(alert, isNull);
        }
      });
    }
  });
}
