import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:barbu_score/commons/widgets/player_icon.dart';
import 'package:barbu_score/pages/prepare_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils.dart';
import '../utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Préparer la partie"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var nbPlayers = kNbPlayersMin; nbPlayers <= kNbPlayersMax; nbPlayers++) {
    patrolWidgetTest("should display $nbPlayers players", ($) async {
      await $.pumpWidget(_createPage($, nbPlayers: nbPlayers));

      expect($(PlayerIcon), findsNWidgets(nbPlayers));
    });
  }
}

Widget _createPage(PatrolTester $, {int nbPlayers = nbPlayersByDefault}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);

  final mockPlayGame = MockPlayGameNotifier();
  mockGame(mockPlayGame, nbPlayers: nbPlayers);

  final container = ProviderContainer(
    overrides: [playGameProvider.overrideWith((_) => mockPlayGame)],
  );

  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: PrepareGame()),
  );
}
