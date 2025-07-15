import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
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

    expect($("Quel est l'ordre des joueurs ?"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });

  patrolWidgetTest("should create page with default ordered players",
      ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);

    await $.pumpWidget(_createPage(mockPlayGame));

    for (var (index, player) in game.players.indexed) {
      expect(
          $(ReorderableDragStartListener).at(index).containing($(player.name)),
          findsOneWidget);
    }
    final validateButton =
        ($.tester.firstWidget(findValidateScoresButton($)) as ElevatedButton);
    expect(validateButton.onPressed, isNotNull);
  });
  patrolWidgetTest("should reorder players and validate", ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);
    final newFirstPlayerIndex = game.players.length - 1;
    final expectedContract = DominoContractModel(rankOfPlayer: {
      for (var (index, player) in game.players.indexed)
        player.name: index == newFirstPlayerIndex ? 0 : index + 1
    });

    await $.pumpWidget(_createPage(mockPlayGame));

    await $.tester.drag(
      $(ReorderableDragStartListener).at(newFirstPlayerIndex),
      const Offset(0, -500),
    );
    await findValidateScoresButton($).tap();

    expect($(ChooseContract), findsOneWidget);
    verify(mockPlayGame.finishContract(expectedContract));
    verify(mockPlayGame.nextPlayer());
  });
}

Widget _createPage([MockPlayGameNotifier? mockPlayGame]) {
  final mockStorage = MockMyStorage();
  mockActiveContracts(mockStorage);

  if (mockPlayGame == null) {
    mockPlayGame = MockPlayGameNotifier();
    mockGame(mockPlayGame);
  }
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
              builder: (_, __) => const DominoContractPage()),
          GoRoute(
            path: Routes.chooseContract,
            builder: (_, __) => const ChooseContract(),
          ),
        ],
      ),
    ),
  );
}
