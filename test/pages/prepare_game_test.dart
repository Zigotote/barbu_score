import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/utils/globals.dart';
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
  for (var testData in List.generate(
    kNbPlayersMax - kNbPlayersMin,
    (index) => (
      nbPlayers: kNbPlayersMin + index,
      nbCardsNumbersToTakeOut: 7 - 2 * index
    ),
  )) {
    final nbPlayers = testData.nbPlayers;
    patrolWidgetTest(
        "should ask to remove ${testData.nbCardsNumbersToTakeOut} for $nbPlayers",
        ($) async {
      await $.pumpWidget(_createPage($, nbPlayers: nbPlayers));

      expect($(PlayerIcon), findsNWidgets(nbPlayers));
      expect(PrepareGame.getCardsToTakeOut(nbPlayers).length,
          testData.nbCardsNumbersToTakeOut);
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
