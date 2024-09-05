import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:barbu_score/commons/widgets/alert_dialog.dart';
import 'package:barbu_score/pages/settings/notifiers/contract_settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils.dart';
import '../../../utils.mocks.dart';

main() {
  group("#alertChangeIsActive", () {
    for (var hasContracts in [true, false]) {
      test("should return alert if trumps contract has no contracts", () {
        final settings = TrumpsContractSettings(
          isActive: true,
          contracts: {
            for (var contract in TrumpsContractSettings.availableContracts)
              contract.name: hasContracts
          },
        );
        final contractNotifier =
            ContractSettingsNotifier(settings, storedGame: null);

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
      (isActive: true, hasBeenPlayed: true),
      (isActive: true, hasBeenPlayed: false),
      (isActive: false, hasBeenPlayed: true),
      (isActive: false, hasBeenPlayed: false)
    ]) {
      final shouldHaveAlert = testData.isActive && testData.hasBeenPlayed;
      test(
          "should${shouldHaveAlert ? "" : " not"} return alert if contract is${testData.isActive ? "" : " not"} active and has${testData.hasBeenPlayed ? "" : " not"} been played by player",
          () {
        const contract = ContractsInfo.barbu;
        final settings = contract.defaultSettings.copy()
          ..isActive = testData.isActive;

        final contractNotifier = ContractSettingsNotifier(
          settings,
          storedGame: createGame(
            4,
            testData.hasBeenPlayed ? [defaultBarbu] : [],
          ),
        );

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
