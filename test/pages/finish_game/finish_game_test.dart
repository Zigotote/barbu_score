import 'package:barbu_score/commons/providers/contracts_manager.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/widgets/ordered_players_scores.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/finish_game/finish_game.dart';
import 'package:barbu_score/pages/finish_game/widgets/game_table.dart';
import 'package:barbu_score/pages/my_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

void main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Fin de partie"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  patrolWidgetTest("should change tab in page", ($) async {
    await $.pumpWidget(_createPage($));

    expect(
      $(
        OrderedPlayersScores,
      ).which((OrderedPlayersScores widget) => widget.isGameFinished),
      findsOneWidget,
    );
    expect($(GameTable), findsNothing);

    await $("Scores par contrat").tap();
    expect($(OrderedPlayersScores), findsNothing);
    expect($(GameTable), findsOneWidget);

    await $("Classement").tap();
    expect(
      $(
        OrderedPlayersScores,
      ).which((OrderedPlayersScores widget) => widget.isGameFinished),
      findsOneWidget,
    );
    expect($(GameTable), findsNothing);
  });
  patrolWidgetTest("should go to home page", ($) async {
    await $.pumpWidget(_createPage($));

    await $("Retour à l'accueil").tap();

    expect($(MyHome), findsOneWidget);
  });
}

Widget _createPage(PatrolTester $) {
  final container = ProviderContainer(
    overrides: [
      contractsManagerProvider.overrideWith((_) => MockContractsManager()),
      logProvider.overrideWithValue(MockMyLog()),
      playGameProvider.overrideWith((_) => MockPlayGameNotifier()),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: Routes.finishGame,
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => const MyHome()),
          GoRoute(
            path: Routes.finishGame,
            builder: (_, _) => const FinishGame(),
          ),
        ],
      ),
    ),
  );
}
