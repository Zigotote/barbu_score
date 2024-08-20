import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/settings/domino_contract_settings.dart';
import 'package:barbu_score/pages/settings/individual_scores_contract_settings.dart';
import 'package:barbu_score/pages/settings/my_settings.dart';
import 'package:barbu_score/pages/settings/one_looser_contract_settings.dart';
import 'package:barbu_score/pages/settings/trumps_contract_settings.dart';
import 'package:barbu_score/pages/settings/widgets/my_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../fake/storage.dart';
import '../../utils.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Paramètres"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var activeContracts in [
    ContractsInfo.values,
    [ContractsInfo.barbu],
    [ContractsInfo.barbu, ContractsInfo.trumps, ContractsInfo.domino]
  ]) {
    patrolWidgetTest(
        "should display ${activeContracts.length} active contracts from storage",
        ($) async {
      await $.pumpWidget(_createPage(activeContracts));

      expect($("ON"), findsNWidgets(activeContracts.length));
      expect(
        $("OFF"),
        findsNWidgets(ContractsInfo.values.length - activeContracts.length),
      );
    });
  }
  for (var modifiedContract in ContractsInfo.values) {
    for (var isModified in [true, false]) {
      patrolWidgetTest(
          "should ${isModified ? "reload" : "keep"} $modifiedContract activation on settings ${isModified ? "" : "not "}changed",
          ($) async {
        await $.pumpWidget(_createPage());

        // Go to contract settings page
        await $.scrollUntilVisible(finder: $(modifiedContract.displayName));
        await $(modifiedContract.displayName)
            .tap(settlePolicy: SettlePolicy.trySettle);

        // Activate contract
        expect(($.tester.firstWidget($(Switch)) as Switch).value, true);
        if (isModified) {
          await $(MySwitch).tap(settlePolicy: SettlePolicy.noSettle);
          expect(($.tester.firstWidget($(Switch)) as Switch).value, false);
        }

        // Go back to global settings page
        await $(Icons.arrow_back).tap(settlePolicy: SettlePolicy.noSettle);
        await $.pump();

        if (isModified) {
          expect($("Modifications sauvegardées"), findsOneWidget);
          expect(
              $(ElevatedButtonWithIndicator)
                  .containing($(modifiedContract.displayName))
                  .containing($("OFF")),
              findsOneWidget);
          expect($("ON"), findsNWidgets(ContractsInfo.values.length - 1));
        } else {
          expect($("Modifications sauvegardées"), findsNothing);
          expect($("ON"), findsNWidgets(ContractsInfo.values.length));
        }
      });
    }
  }
}

Widget _createPage(
    [List<ContractsInfo> activeContracts = ContractsInfo.values]) {
  final container = ProviderContainer(
    overrides: [
      storageProvider.overrideWithValue(
        FakeStorage(activeContracts: activeContracts),
      ),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: const MySettings(),
      routes: {
        Routes.barbuOrNoLastTrickSettings: (context) =>
            OneLooserContractSettingsPage(
                Routes.getArgument<ContractsInfo>(context)),
        Routes.noSomethingScoresSettings: (context) =>
            IndividualScoresContractSettingsPage(
                Routes.getArgument<ContractsInfo>(context)),
        Routes.dominoSettings: (_) => const DominoContractSettingsPage(),
        Routes.trumpsSettings: (_) => const TrumpsContractSettingsPage(),
      },
    ),
  );
}
