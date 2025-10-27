import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/custom_buttons.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/choose_contract.dart';
import 'package:barbu_score/pages/contract_scores/domino_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

void main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage());

    expect($("Qui a fini 1er ?"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  patrolWidgetTest("should open and close domino rules", ($) async {
    await $.pumpWidget(_createPage());

    await $.tap($(Icons.question_mark_outlined));
    expect($(DraggableScrollableSheet), findsOneWidget);
    expect($("Règles Réussite"), findsOneWidget);

    await $.tap($(Icons.close));
    expect($(DraggableScrollableSheet), findsNothing);
  });

  patrolWidgetTest("should create page with disabled validate scores button", (
    $,
  ) async {
    await $.pumpWidget(_createPage());

    expect($(ElevatedButtonWithIndicator), findsNWidgets(nbPlayersByDefault));
    expect(
      $(ElevatedButtonWithIndicator).containing($(Container)),
      findsNothing,
    );
    expect(findValidateScoresButtonWidget($).onPressed, isNull);
  });

  patrolWidgetTest("should rank players and validate", ($) async {
    final mockPlayGame = mockPlayGameNotifier();
    final game = mockPlayGame.game;
    final expectedContract = DominoContractModel(
      rankOfPlayer: {
        for (var (index, player) in game.players.indexed) player.name: index,
      },
    );
    await $.pumpWidget(_createPage());

    for (var playerRank = 0; playerRank < game.players.length; playerRank++) {
      await $(ElevatedButtonWithIndicator).at(playerRank).tap();
      expect(
        $(
          ElevatedButtonWithIndicator,
        ).at(playerRank).containing((playerRank + 1).toString()),
        findsOneWidget,
      );
    }
    await findValidateScoresButton($).tap();

    expect($(ChooseContract), findsOneWidget);
    verify(mockPlayGame.finishContract(expectedContract));
    verify(mockPlayGame.nextPlayer());
  });
}

Widget _createPage([MockPlayGameNotifier? mockPlayGame]) {
  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage);
  mockPlayGame ??= mockPlayGameNotifier();

  final container = ProviderContainer(
    overrides: [
      logProvider.overrideWithValue(MockMyLog()),
      playGameProvider.overrideWith((_) => mockPlayGame!),
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
            builder: (_, _) => const DominoContractPage(),
          ),
          GoRoute(
            path: Routes.chooseContract,
            builder: (_, _) => const ChooseContract(),
          ),
        ],
      ),
    ),
  );
}
