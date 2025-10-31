import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/commons/utils/router_extension.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/domino_contract.dart';
import 'package:barbu_score/pages/contract_scores/multiple_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/one_looser_contract.dart';
import 'package:barbu_score/pages/contract_scores/salad_contract.dart';
import 'package:barbu_score/pages/my_scores.dart';
import 'package:barbu_score/pages/rules/models/rules_page_name.dart';
import 'package:barbu_score/pages/rules/my_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/french_material_app.dart';
import '../utils/utils.dart';
import '../utils/utils.mocks.dart';

void main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Tour de"), findsOneWidget);
    expect($(defaultPlayerNames[0]), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var contracts in [
    (
      active: ContractsInfo.values,
      played: [
        ContractWithPointsModel(contract: ContractsInfo.barbu),
        SaladContractModel(),
        DominoContractModel(),
      ],
    ),
    (active: [ContractsInfo.barbu], played: <AbstractContractModel>[]),
    (
      active: [ContractsInfo.barbu, ContractsInfo.salad, ContractsInfo.domino],
      played: [ContractWithPointsModel(contract: ContractsInfo.barbu)],
    ),
  ]) {
    final activeContracts = contracts.active;
    final playedContracts = contracts.played;
    patrolWidgetTest("should display enabled contracts $activeContracts", (
      $,
    ) async {
      await $.pumpWidget(_createPage($, activeContracts: activeContracts));

      expect($(ElevatedButton), findsNWidgets(activeContracts.length));
      for (var contract in ContractsInfo.values) {
        final isActiveContract = activeContracts.contains(contract);
        expect(
          $(Key(contract.name)),
          isActiveContract ? findsOneWidget : findsNothing,
        );
        if (isActiveContract) {
          expect(
            $(
              Key(contract.name),
            ).which((widget) => (widget as ElevatedButton).onPressed != null),
            findsOneWidget,
          );
        }
      }
    });
    patrolWidgetTest("should display disabled contracts $activeContracts", (
      $,
    ) async {
      await $.pumpWidget(
        _createPage(
          $,
          activeContracts: activeContracts,
          playedContracts: playedContracts,
        ),
      );

      expect($(ElevatedButton), findsNWidgets(activeContracts.length));
      for (var contract in activeContracts) {
        expect($(Key(contract.name)), findsOneWidget);
        expect(
          $(Key(contract.name)).which((widget) {
            final onPressed = (widget as ElevatedButton).onPressed;
            return playedContracts.any(
                  (playedContract) => contract.name == playedContract.name,
                )
                ? onPressed == null
                : onPressed != null;
          }),
          findsOneWidget,
        );
      }
    });
  }
  group("Navigation", () {
    patrolWidgetTest("should go to rules page", ($) async {
      await $.pumpWidget(_createPage($));

      await $(Icons.question_mark_outlined).tap();
      expect($(MyRules), findsOneWidget);
      expect(
        find.textContaining("Le jeu du Barbu comporte les contrats"),
        findsOneWidget,
      );

      await $(Icons.close).tap();
      expect($(ChooseContract), findsOneWidget);
    });
    for (var testData in [
      (
        contract: ContractsInfo.barbu,
        nbPlayers: kNbPlayersMaxForOneDeck,
        expectedPage: OneLooserContractPage,
      ),
      (
        contract: ContractsInfo.barbu,
        nbPlayers: kNbPlayersMaxForOneDeck + 1,
        expectedPage: MultipleLooserContractPage,
      ),
      (
        contract: ContractsInfo.noHearts,
        nbPlayers: kNbPlayersMin,
        expectedPage: MultipleLooserContractPage,
      ),
      (
        contract: ContractsInfo.noHearts,
        nbPlayers: kNbPlayersMax,
        expectedPage: MultipleLooserContractPage,
      ),
      (
        contract: ContractsInfo.noQueens,
        nbPlayers: kNbPlayersMin,
        expectedPage: MultipleLooserContractPage,
      ),
      (
        contract: ContractsInfo.noQueens,
        nbPlayers: kNbPlayersMax,
        expectedPage: MultipleLooserContractPage,
      ),
      (
        contract: ContractsInfo.noTricks,
        nbPlayers: kNbPlayersMin,
        expectedPage: MultipleLooserContractPage,
      ),
      (
        contract: ContractsInfo.noTricks,
        nbPlayers: kNbPlayersMax,
        expectedPage: MultipleLooserContractPage,
      ),
      (
        contract: ContractsInfo.noLastTrick,
        nbPlayers: kNbPlayersMin,
        expectedPage: OneLooserContractPage,
      ),
      (
        contract: ContractsInfo.noLastTrick,
        nbPlayers: kNbPlayersMax,
        expectedPage: OneLooserContractPage,
      ),
      (
        contract: ContractsInfo.salad,
        nbPlayers: kNbPlayersMin,
        expectedPage: SaladContractPage,
      ),
      (
        contract: ContractsInfo.salad,
        nbPlayers: kNbPlayersMax,
        expectedPage: SaladContractPage,
      ),
      (
        contract: ContractsInfo.domino,
        nbPlayers: kNbPlayersMin,
        expectedPage: DominoContractPage,
      ),
      (
        contract: ContractsInfo.domino,
        nbPlayers: kNbPlayersMax,
        expectedPage: DominoContractPage,
      ),
    ]) {
      patrolWidgetTest(
        "should go to ${testData.contract} score pages with ${testData.nbPlayers} players and keep contract available",
        ($) async {
          await $.pumpWidget(_createPage($, nbPlayers: testData.nbPlayers));

          await $(Key(testData.contract.name)).tap();
          expect($(testData.expectedPage), findsOneWidget);

          await $(IconButton).tap();
          expect($(ChooseContract), findsOneWidget);
          expect(
            $(
              Key(testData.contract.name),
            ).which((widget) => (widget as ElevatedButton).onPressed != null),
            findsOneWidget,
          );
        },
      );
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

Widget _createPage(
  PatrolTester $, {
  List<ContractsInfo> activeContracts = ContractsInfo.values,
  int nbPlayers = nbPlayersByDefault,
  List<AbstractContractModel> playedContracts = const [],
}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);
  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage, activeContracts);

  final mockPlayGame = mockPlayGameNotifier(
    playedContracts: playedContracts,
    nbPlayers: nbPlayers,
  );

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
          GoRoute(path: Routes.home, builder: (_, _) => const ChooseContract()),
          GoRoute(
            path: Routes.rules,
            name: Routes.rules,
            builder: (_, state) {
              final rulesPageName =
                  state.uri.queryParameters[MyGoRouterState.rulesPage];
              return MyRules(
                startingPage: rulesPageName != null
                    ? RulesPageName.fromName(rulesPageName)
                    : null,
              );
            },
          ),
          GoRoute(
            path:
                "${Routes.oneLooserScores}/:${MyGoRouterState.contractParameter}",
            builder: (_, state) => OneLooserContractPage(
              state.contract,
              contractModel: state.extra as ContractWithPointsModel?,
            ),
          ),
          GoRoute(
            path:
                "${Routes.noSomethingScores}/:${MyGoRouterState.contractParameter}",
            builder: (_, state) => MultipleLooserContractPage(
              state.contract,
              contractModel: state.extra as ContractWithPointsModel?,
            ),
          ),
          GoRoute(
            path: Routes.dominoScores,
            builder: (_, _) => const DominoContractPage(),
          ),
          GoRoute(
            path: Routes.saladScores,
            builder: (_, _) => const SaladContractPage(),
          ),
          GoRoute(path: Routes.scores, builder: (_, _) => const MyScores()),
        ],
      ),
    ),
  );
}
