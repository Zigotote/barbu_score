import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/notifiers/contracts_manager.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:barbu_score/commons/widgets/player_score_button.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/my_home.dart';
import 'package:barbu_score/pages/my_scores.dart';
import 'package:barbu_score/pages/scores_by_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils.dart';
import '../utils.mocks.dart';

main() {
  patrolWidgetTest("should be accessible", ($) async {
    await $.pumpWidget(_createPage($));

    expect($("Scores"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  patrolWidgetTest("should save game and go to home", ($) async {
    final mockStorage = MockMyStorage2();
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);

    await $.pumpWidget(
      _createPage($, mockStorage: mockStorage, mockPlayGame: mockPlayGame),
    );

    await $("Sauvegarder et quitter").tap();

    expect($(MyHome), findsOneWidget);
    expect($("Partie sauvegardée"), findsOneWidget);
    verify(mockStorage.saveGame(game));
  });
  patrolWidgetTest("should go to player scores page", ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);

    await $.pumpWidget(_createPage($, mockPlayGame: mockPlayGame));

    // All player scores should be at 0
    expect($("0 points"), findsNWidgets(game.players.length));
    for (int i = 0; i < game.players.length; i++) {
      await $(PlayerScoreButton).at(i).tap();
      expect($(ScoresByPlayer), findsOneWidget);

      await $(Icons.arrow_back).tap();
      expect($(MyScores), findsOneWidget);
    }
  });
  for (var isFinished in [true, false]) {
    patrolWidgetTest(
        "should display ordered scores for ${isFinished ? "finished" : "current"} game",
        ($) async {
      final mockPlayGame = MockPlayGameNotifier();
      final game = mockGame(mockPlayGame);
      game.isFinished = isFinished;
      final mockContractManager = MockContractsManager();
      when(mockContractManager.scoresByContract(game.players[0])).thenReturn({
        ContractsInfo.barbu: {
          for (var (index, player) in game.players.indexed)
            player.name: index == 0 ? 50 : 0
        }
      });
      when(mockContractManager.scoresByContract(game.players[1])).thenReturn({
        ContractsInfo.noQueens: {
          for (var player in game.players) player.name: 10
        }
      });
      when(mockContractManager.scoresByContract(game.players[2])).thenReturn({
        ContractsInfo.noTricks: {
          for (var (index, player) in game.players.indexed)
            player.name: index % 2 == 0 ? 20 : 0
        }
      });

      await $.pumpWidget(
        _createPage(
          $,
          mockPlayGame: mockPlayGame,
          mockContractsManager: mockContractManager,
        ),
      );

      final playerScoreButtons =
          $.tester.widgetList($(PlayerScoreButton)).toList();
      for (var (index, expectedScore) in [
        (playerIndex: 1, score: 10, worstEnnemyIndex: 1, bestFriendIndex: 0),
        (playerIndex: 3, score: 10, worstEnnemyIndex: 1, bestFriendIndex: 0),
        (playerIndex: 2, score: 30, worstEnnemyIndex: 2, bestFriendIndex: 0),
        (playerIndex: 0, score: 80, worstEnnemyIndex: 0, bestFriendIndex: 1)
      ].indexed) {
        final button = playerScoreButtons[index] as PlayerScoreButton;
        expect(button.player, game.players[expectedScore.playerIndex]);
        expect(button.score, expectedScore.score);
        if (!isFinished) {
          expect(button.displayMedal, isFalse);
          expect(button.bestFriend, isNull);
          expect(button.worstEnnemy, isNull);
        } else {
          expect(button.displayMedal, index == 0);
          expect(
            button.worstEnnemy,
            game.players[expectedScore.worstEnnemyIndex],
          );
          expect(
            button.bestFriend,
            game.players[expectedScore.bestFriendIndex],
          );
        }
      }
    });
  }
}

Widget _createPage(PatrolTester $,
    {MockMyStorage2? mockStorage,
    MockPlayGameNotifier? mockPlayGame,
    MockContractsManager? mockContractsManager}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);
  mockStorage ??= MockMyStorage2();
  mockActiveContracts(mockStorage);

  if (mockPlayGame == null) {
    mockPlayGame = MockPlayGameNotifier();
    mockGame(mockPlayGame);
  }

  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith((_) => mockPlayGame!),
      storageProvider.overrideWithValue(mockStorage),
      contractsManagerProvider
          .overrideWith((_) => mockContractsManager ?? MockContractsManager())
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: const MyHome(),
      initialRoute: Routes.scores,
      routes: {
        Routes.scores: (_) => const MyScores(),
        Routes.scoresByPlayer: (context) =>
            ScoresByPlayer(Routes.getArgument<Player>(context))
      },
    ),
  );
}
