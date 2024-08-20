import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/notifiers/contracts_manager.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/widgets/ordered_players_scores.dart';
import 'package:barbu_score/commons/widgets/player_score_button.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/finish_game/finish_game.dart';
import 'package:barbu_score/pages/finish_game/widgets/game_table.dart';
import 'package:barbu_score/pages/my_home.dart';
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

    expect($("Fin de partie"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  patrolWidgetTest("should change tab in page", ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);
    final mockContractManager = MockContractsManager();
    when(mockContractManager.sumScoresByContract(game.players)).thenReturn({
      ContractsInfo.barbu: {
        for (var (index, player) in game.players.indexed)
          player.name: index == 0 ? 50 : 0
      }
    });

    await $.pumpWidget(
      _createPage(
        $,
        mockPlayGame: mockPlayGame,
        mockContractsManager: mockContractManager,
      ),
    );

    expect($(OrderedPlayersScores), findsOneWidget);
    expect($(GameTable), findsNothing);

    await $("Scores par contrat").tap();
    expect($(OrderedPlayersScores), findsNothing);
    expect($(GameTable), findsOneWidget);

    await $("Classement").tap();
    expect($(OrderedPlayersScores), findsOneWidget);
    expect($(GameTable), findsNothing);
  });
  patrolWidgetTest("should display ranking and go to player scores page",
      ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);
    final mockContractManager = MockContractsManager();
    when(mockContractManager.scoresByContract(game.players[0])).thenReturn({
      ContractsInfo.barbu: {
        for (var (index, player) in game.players.indexed)
          player.name: index == 0 ? 50 : 0
      }
    });
    when(mockContractManager.scoresByContract(game.players[1])).thenReturn({
      ContractsInfo.noQueens: {for (var player in game.players) player.name: 10}
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
  });
  patrolWidgetTest("should display scores by contract", ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);
    final mockContractManager = MockContractsManager();
    when(mockContractManager.sumScoresByContract(game.players)).thenReturn({
      ContractsInfo.barbu: {
        for (var (index, player) in game.players.indexed)
          player.name: index == 0 ? 50 : 0
      },
      ContractsInfo.noHearts: {
        for (var player in game.players) player.name: 15
      },
      ContractsInfo.noQueens: {
        for (var player in game.players) player.name: 20
      },
      ContractsInfo.noTricks: {
        for (var (index, player) in game.players.indexed)
          player.name: index % 2 == 0 ? 10 : 0
      },
      ContractsInfo.noLastTrick: {
        for (var (index, player) in game.players.indexed)
          player.name: index == 0 ? 40 : 0
      },
      ContractsInfo.trumps: {for (var player in game.players) player.name: 0},
      ContractsInfo.domino: {
        for (var (index, player) in game.players.indexed)
          player.name: -10 * index
      },
    });

    await $.pumpWidget(
      _createPage(
        $,
        mockPlayGame: mockPlayGame,
        mockContractsManager: mockContractManager,
      ),
    );
    await $("Scores par contrat").tap();

    // Verify scores lines
    // Barbu
    expect(($("50")), findsOneWidget);
    // No hearts
    expect(($("15")), findsNWidgets(game.players.length));
    // No queens
    expect(($("20")), findsNWidgets(game.players.length));
    // No tricks
    final nbScoresForNoTricks = (game.players.length / 2).round();
    expect(($("10")), findsNWidgets(nbScoresForNoTricks));
    // No last trick
    expect(($("40")), findsOneWidget);
    // Domino
    expect(($("-10")), findsOneWidget);
    expect(($("-20")), findsOneWidget);
    expect(($("-30")), findsOneWidget);
    // Zeros for players who didn't score previously
    expect(
      ($("0")),
      findsNWidgets((game.players.length - 1) * 2 // barbu and no last trick
              +
              (game.players.length / 2).round() // no tricks
              +
              1 // domino
              +
              game.players.length // trumps
          ),
    );
    // Empty lines
    expect(($("/")), findsNothing);
    // Total
    expect($("135"), findsOneWidget);
    expect($("25"), findsNWidgets(2));
    expect($("5"), findsOneWidget);
  });
  patrolWidgetTest("should go to home page", ($) async {
    await $.pumpWidget(_createPage($));

    await $("Retour à l'accueil").tap();

    expect($(MyHome), findsOneWidget);
  });
}

Widget _createPage(PatrolTester $,
    {MockPlayGameNotifier? mockPlayGame,
    MockContractsManager? mockContractsManager}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);
  if (mockPlayGame == null) {
    mockPlayGame = MockPlayGameNotifier();
    mockGame(mockPlayGame);
  }

  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith((_) => mockPlayGame!),
      contractsManagerProvider
          .overrideWith((_) => mockContractsManager ?? MockContractsManager())
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: const MyHome(),
      initialRoute: Routes.finishGame,
      routes: {
        Routes.finishGame: (_) => const FinishGame(),
        Routes.scoresByPlayer: (context) =>
            ScoresByPlayer(Routes.getArgument<Player>(context))
      },
    ),
  );
}
