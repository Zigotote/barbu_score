import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/contracts_manager.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/router_extension.dart';
import 'package:barbu_score/commons/widgets/ordered_players_scores.dart';
import 'package:barbu_score/commons/widgets/player_score_button.dart';
import 'package:barbu_score/main.dart';
import 'package:barbu_score/pages/scores_by_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/french_material_app.dart';
import '../../utils/utils.dart';
import '../../utils/utils.mocks.dart';

final _defaultAscendingScores = [
  (playerIndex: 1, score: 10, worstEnnemyIndex: 1, bestFriendIndex: 0),
  (playerIndex: 3, score: 10, worstEnnemyIndex: 1, bestFriendIndex: 0),
  (playerIndex: 2, score: 30, worstEnnemyIndex: 2, bestFriendIndex: 0),
  (playerIndex: 0, score: 80, worstEnnemyIndex: 0, bestFriendIndex: 1),
];
final _defaultDescendingScores = [
  (playerIndex: 0, score: 80, worstEnnemyIndex: 1, bestFriendIndex: 0),
  (playerIndex: 2, score: 30, worstEnnemyIndex: 0, bestFriendIndex: 2),
  (playerIndex: 1, score: 10, worstEnnemyIndex: 0, bestFriendIndex: 1),
  (playerIndex: 3, score: 10, worstEnnemyIndex: 0, bestFriendIndex: 1),
];

void main() {
  patrolWidgetTest("should go to player scores page", ($) async {
    final mockPlayGame = mockPlayGameNotifier();
    final game = mockPlayGame.game;

    await $.pumpWidget(_createPage($, mockPlayGame: mockPlayGame));

    // All player scores should be at 0
    expect($("0 points"), findsNWidgets(game.players.length));
    for (int i = 0; i < game.players.length; i++) {
      await $(PlayerScoreButton).at(i).tap();
      expect($(ScoresByPlayer), findsOneWidget);
      expect($("Contrats de ${game.players[i].name}"), findsOneWidget);
      expect($(game.players[i].name), findsOneWidget);

      await $(Icons.arrow_back).tap();
      expect($(ScoresByPlayer), findsNothing);
    }
  });
  for (var testData in [
    (isAscending: true, isFinished: false),
    (isAscending: true, isFinished: true),
    (isAscending: false, isFinished: false),
    (isAscending: false, isFinished: true),
  ]) {
    final mockPlayGame = mockPlayGameNotifier();
    final game = mockPlayGame.game;
    game.isFinished = testData.isFinished;
    patrolWidgetTest(
      "should display ${testData.isAscending ? "ascending" : "descending"} ordered scores ${getGameStateText(game)}",
      ($) async {
        final mockContractManager = MockContractsManager();
        when(mockContractManager.scoresByContract(game.players[0])).thenReturn({
          ContractsInfo.barbu: {
            for (var (index, player) in game.players.indexed)
              player.name: index == 0 ? 50 : 0,
          },
        });
        when(mockContractManager.scoresByContract(game.players[1])).thenReturn({
          ContractsInfo.noQueens: {
            for (var player in game.players) player.name: 10,
          },
        });
        when(mockContractManager.scoresByContract(game.players[2])).thenReturn({
          ContractsInfo.noTricks: {
            for (var (index, player) in game.players.indexed)
              player.name: index % 2 == 0 ? 20 : 0,
          },
        });

        await $.pumpWidget(
          _createPage(
            $,
            mockPlayGame: mockPlayGame,
            mockContractsManager: mockContractManager,
            isAscending: testData.isAscending,
          ),
        );

        final expectedScores = testData.isAscending
            ? _defaultAscendingScores
            : _defaultDescendingScores;
        final playerScoreButtons = $.tester
            .widgetList($(PlayerScoreButton))
            .toList();
        for (var (index, expectedScore) in expectedScores.indexed) {
          final button = playerScoreButtons[index] as PlayerScoreButton;
          final isFirstPlayer = testData.isAscending
              ? index == 0 || index == 1
              : index == 0;
          expect(button.player, game.players[expectedScore.playerIndex]);
          expect(button.score, expectedScore.score);
          expect(
            button.displayMedal,
            testData.isFinished ? isFirstPlayer : isFalse,
          );
          expect(
            button.worstEnnemy,
            testData.isFinished
                ? game.players[expectedScore.worstEnnemyIndex]
                : isNull,
          );
          expect(
            button.bestFriend,
            testData.isFinished
                ? game.players[expectedScore.bestFriendIndex]
                : isNull,
          );
        }
      },
    );
  }
}

Widget _createPage(
  PatrolTester $, {
  required MockPlayGameNotifier mockPlayGame,
  MockContractsManager? mockContractsManager,
  bool isAscending = true,
}) {
  final mockStorage = MockMyStorage();
  when(
    mockStorage.getGameSettings(),
  ).thenReturn(GameSettings(goalIsMinScore: isAscending));

  final container = ProviderContainer(
    overrides: [
      contractsManagerProvider.overrideWith(
        (_) => mockContractsManager ?? MockContractsManager(),
      ),
      logProvider.overrideWithValue(MockMyLog()),
      storageProvider.overrideWithValue(mockStorage),
      playGameProvider.overrideWith((_) => mockPlayGame),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (_, _) => Scaffold(
              body: OrderedPlayersScores(
                isGameFinished: mockPlayGame.game.isFinished,
              ),
            ),
          ),
          GoRoute(
            path: Routes.scoresByPlayer,
            name: Routes.scoresByPlayer,
            builder: (_, state) => ScoresByPlayer(
              state.uri.queryParameters[MyGoRouterState.playerParameter]!,
            ),
          ),
        ],
      ),
    ),
  );
}
