import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/router_extension.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/domino_contract.dart';
import 'package:barbu_score/pages/contract_scores/multiple_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/salad_contract.dart';
import 'package:barbu_score/pages/my_scores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/french_material_app.dart';
import '../utils/utils.dart';
import '../utils/utils.mocks.dart';

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
        SaladContractModel(),
        DominoContractModel(),
      ]
    ),
    (active: [ContractsInfo.barbu], played: <AbstractContractModel>[]),
    (
      active: [ContractsInfo.barbu, ContractsInfo.salad, ContractsInfo.domino],
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
          $(Key(contract.name)),
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
      await $.pumpWidget(
        _createPage(
          $,
          activeContracts: activeContracts,
          playedContracts: playedContracts,
        ),
      );

      expect($(ElevatedButton), findsNWidgets(activeContracts.length + 1));
      for (var contract in activeContracts) {
        expect($(Key(contract.name)), findsOneWidget);
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

      await $(IconButton).tap();
      expect($(ChooseContract), findsOneWidget);
    });
  });
}

Widget _createPage(PatrolTester $,
    {List<ContractsInfo> activeContracts = ContractsInfo.values,
    List<AbstractContractModel> playedContracts = const []}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);
  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage, activeContracts);

  final mockPlayGame = MockPlayGameNotifier();
  mockGame(mockPlayGame, playedContracts: playedContracts);

  final container = ProviderContainer(
    overrides: [
      logProvider.overrideWithValue(MockMyLog()),
      playGameProvider.overrideWith((_) => mockPlayGame),
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (_, __) => const ChooseContract(),
          ),
          GoRoute(
            path:
                "${Routes.barbuOrNoLastTrickScores}/:${MyGoRouterState.contractParameter}",
            builder: (_, state) => OneLooserContractPage(
              state.contract,
              contractModel: state.extra as OneLooserContractModel?,
            ),
          ),
          GoRoute(
            path:
                "${Routes.noSomethingScores}/:${MyGoRouterState.contractParameter}",
            builder: (_, state) => MultipleLooserContractPage(
              state.contract,
              contractModel: state.extra as MultipleLooserContractModel?,
            ),
          ),
          GoRoute(
            path: Routes.dominoScores,
            builder: (_, __) => const DominoContractPage(),
          ),
          GoRoute(
            path: Routes.saladScores,
            builder: (_, __) => const SaladContractPage(),
          ),
          GoRoute(path: Routes.scores, builder: (_, __) => const MyScores()),
        ],
      ),
    ),
  );
}
