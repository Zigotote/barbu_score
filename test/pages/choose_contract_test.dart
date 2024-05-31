import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/domino_contract.dart';
import 'package:barbu_score/pages/contract_scores/models/contract_route_argument.dart';
import 'package:barbu_score/pages/contract_scores/multiple_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/trumps_contract.dart';
import 'package:barbu_score/pages/my_scores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils.dart';
import '../utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Tour de ${defaultPlayerNames[0]}"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var contracts in [
    (
      active: ContractsInfo.values,
      played: [
        OneLooserContractModel(contract: ContractsInfo.barbu),
        TrumpsContractModel(),
        DominoContractModel(),
      ]
    ),
    (active: [ContractsInfo.barbu], played: <AbstractContractModel>[]),
    (
      active: [ContractsInfo.barbu, ContractsInfo.trumps, ContractsInfo.domino],
      played: [OneLooserContractModel(contract: ContractsInfo.barbu)]
    )
  ]) {
    final activeContracts = contracts.active;
    final playedContracts = contracts.played;
    patrolWidgetTest("should display enabled contracts $activeContracts",
        ($) async {
      await $.pumpWidget(_createPage($, activeContracts: activeContracts));

      expect($(ElevatedButton), findsNWidgets(activeContracts.length + 1));
      for (var contract in ContractsInfo.values) {
        final isActiveContract = activeContracts.contains(contract);
        expect(
          $(contract.displayName),
          isActiveContract ? findsOneWidget : findsNothing,
        );
        if (isActiveContract) {
          expect(
            $(Key(contract.name)).which(
                (widget) => (widget as ElevatedButton).onPressed != null),
            findsOneWidget,
          );
        }
      }
    });
    patrolWidgetTest("should display disabled contracts $activeContracts",
        ($) async {
      await $.pumpWidget(_createPage($,
          activeContracts: activeContracts, playedContracts: playedContracts));

      expect($(ElevatedButton), findsNWidgets(activeContracts.length + 1));
      for (var contract in activeContracts) {
        expect($(contract.displayName), findsOneWidget);
        expect(
          $(Key(contract.name)).which((widget) {
            final onPressed = (widget as ElevatedButton).onPressed;
            return playedContracts.any(
                    (playedContract) => contract.name == playedContract.name)
                ? onPressed == null
                : onPressed != null;
          }),
          findsOneWidget,
        );
      }
    });
  }
  group("Navigation", () {
    for (var contract in ContractsInfo.values) {
      patrolWidgetTest(
          "should go to $contract score pages and keep contract available",
          ($) async {
        await $.pumpWidget(_createPage($));

        await $(Key(contract.name)).tap();
        expect($("Valider les scores"), findsOneWidget);

        await $(IconButton).tap();
        expect($(ChooseContract), findsOneWidget);
        expect(
            $(Key(contract.name)).which(
                (widget) => (widget as ElevatedButton).onPressed != null),
            findsOneWidget);
      });
    }
    patrolWidgetTest("should go to scores page", ($) async {
      await $.pumpWidget(_createPage($));

      await $("Scores").tap();
      expect($(MyScores), findsOneWidget);
    });
  });
}

Widget _createPage(PatrolTester $,
    {List<ContractsInfo> activeContracts = ContractsInfo.values,
    List<AbstractContractModel> playedContracts = const []}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);
  final mockStorage = MockMyStorage2();
  mockActiveContracts(mockStorage, activeContracts);

  final mockPlayGame = MockPlayGameNotifier();
  mockGame(mockPlayGame, playedContracts: playedContracts);

  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith((_) => mockPlayGame),
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: const ChooseContract(), routes: {
      Routes.barbuOrNoLastTrickScores: (context) => OneLooserContractPage(
            ContractRouteArgument(contractInfo: ContractsInfo.barbu),
          ),
      Routes.noSomethingScores: (context) => MultipleLooserContractPage(
            ContractRouteArgument(contractInfo: ContractsInfo.noQueens),
          ),
      Routes.dominoScores: (_) => const DominoContractPage(),
      Routes.trumpsScores: (_) => const TrumpsContractPage(),
      Routes.scores: (_) => const MyScores()
    }),
  );
}
