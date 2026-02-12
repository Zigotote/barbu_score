import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/contracts_manager.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/widgets/ordered_players_scores.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/my_home.dart';
import 'package:barbu_score/pages/my_scores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/french_material_app.dart';
import '../utils/utils.dart';
import '../utils/utils.mocks.dart';

void main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Scores"), findsOneWidget);
    expect($(OrderedPlayersScores), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  patrolWidgetTest("should save game and go to home", ($) async {
    final mockStorage = MockMyStorage();
    final mockPlayGame = mockPlayGameNotifier();
    final game = mockPlayGame.game;

    await $.pumpWidget(
      _createPage($, mockStorage: mockStorage, mockPlayGame: mockPlayGame),
    );

    await $("Sauvegarder et quitter").tap();

    expect($(MyHome), findsOneWidget);
    expect($("Partie sauvegardée"), findsOneWidget);
    verify(mockStorage.saveGame(game));
  });
}

Widget _createPage(
  PatrolTester $, {
  MockMyStorage? mockStorage,
  MockPlayGameNotifier? mockPlayGame,
}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);
  mockStorage ??= MockMyStorage();
  when(mockStorage.getGameSettings()).thenReturn(GameSettings());
  mockActiveContracts(mockStorage);

  mockPlayGame ??= mockPlayGameNotifier();

  final container = ProviderContainer(
    overrides: [
      contractsManagerProvider.overrideWith((_) => MockContractsManager()),
      logProvider.overrideWithValue(MockMyLog()),
      playGameProvider.overrideWith((_) => mockPlayGame!),
      storageProvider.overrideWithValue(mockStorage),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: Routes.scores,
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => const MyHome()),
          GoRoute(path: Routes.scores, builder: (_, _) => const MyScores()),
        ],
      ),
    ),
  );
}
