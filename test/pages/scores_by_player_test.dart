import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/notifiers/contracts_manager.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/notifiers/storage.dart';
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
    await $.pumpWidget(_createPage());

    expect($("Scores"), findsOneWidget);
    expect($.tester.takeException(), isNull);
    await checkAccessibility($.tester);
  });
  for (var activeContractsTest in [
    [ContractsInfo.barbu],
    [ContractsInfo.noTricks, ContractsInfo.barbu, ContractsInfo.trumps],
    ContractsInfo.values
  ]) {
    patrolWidgetTest(
        "should display active contracts in table for $activeContractsTest",
        ($) async {
      final mockPlayGame = MockPlayGameNotifier();
      final game = mockGame(mockPlayGame);
      final mockStorage = MockMyStorage2();
      mockActiveContracts(mockStorage, activeContractsTest);
      await $.pumpWidget(
        _createPage(
          mockStorage: mockStorage,
          mockPlayGame: mockPlayGame,
        ),
      );

      expect($("Contrats de ${game.players[0].name}"), findsOneWidget);
      for (var contract in ContractsInfo.values) {
        expect(
          $(contract.displayName),
          activeContractsTest.contains(contract)
              ? findsOneWidget
              : findsNothing,
        );
      }
      // Contracts scores should be null
      expect(
        $("/"),
        findsNWidgets(game.players.length * activeContractsTest.length),
      );
      // Total scores should be 0
      expect($("Total"), findsOneWidget);
      expect(
        $("0"),
        findsNWidgets(game.players.length),
      );
    });
  }
  patrolWidgetTest("should display scores with some contracts", ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);
    final mockContractManager = MockContractsManager();
    when(mockContractManager.scoresByContract(game.players[0])).thenReturn({
      ContractsInfo.barbu: {
        for (var (index, player) in game.players.indexed)
          player.name: index == 0 ? 50 : 0
      },
      ContractsInfo.noHearts: null,
      ContractsInfo.noQueens: {
        for (var player in game.players) player.name: 10
      },
      ContractsInfo.noTricks: {
        for (var (index, player) in game.players.indexed)
          player.name: index % 2 == 0 ? 20 : 0
      },
      ContractsInfo.noLastTrick: null,
      ContractsInfo.trumps: null,
      ContractsInfo.domino: null,
    });
    await $.pumpWidget(
      _createPage(
        mockContractsManager: mockContractManager,
        mockPlayGame: mockPlayGame,
      ),
    );

    // Verify scores lines
    // Barbu
    expect($("50"), findsOneWidget);
    // No queens
    final nbScoresForNoQueens = game.players.length;
    expect(
      ($("10")),
      findsNWidgets(
          nbScoresForNoQueens + 2), // 2 players have a total score of 10
    );
    // No tricks
    final nbScoresForNoTricks = (game.players.length / 2).round();
    expect($("20"), findsNWidgets(nbScoresForNoTricks));
    // Zeros for players who didn't score previously
    expect(
      ($("0")),
      findsNWidgets(
        game.players.length * 3 -
            (1 + nbScoresForNoTricks + nbScoresForNoQueens),
      ),
    );
    // Empty lines
    expect($("/"), findsNWidgets(game.players.length * 4));
    // Total
    expect($("80"), findsOneWidget);
    expect($("30"), findsOneWidget);
  });
  patrolWidgetTest("should display scores for all contracts", ($) async {
    final mockPlayGame = MockPlayGameNotifier();
    final game = mockGame(mockPlayGame);
    final mockContractManager = MockContractsManager();
    when(mockContractManager.scoresByContract(game.players[0])).thenReturn({
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
        mockContractsManager: mockContractManager,
        mockPlayGame: mockPlayGame,
      ),
    );

    // Verify scores lines
    // Barbu
    expect($("50"), findsOneWidget);
    // No hearts
    expect($("15"), findsNWidgets(game.players.length));
    // No queens
    expect($("20"), findsNWidgets(game.players.length));
    // No tricks
    final nbScoresForNoTricks = (game.players.length / 2).round();
    expect($("10"), findsNWidgets(nbScoresForNoTricks));
    // No last trick
    expect($("40"), findsOneWidget);
    // Domino
    expect($("-10"), findsOneWidget);
    expect($("-20"), findsOneWidget);
    expect($("-30"), findsOneWidget);
    // Zeros for players who didn't score previously
    expect(
      $("0"),
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
    expect($("/"), findsNothing);
    // Total
    expect($("135"), findsOneWidget);
    expect($("25"), findsNWidgets(2));
    expect($("5"), findsOneWidget);
  });
}

Widget _createPage(
    {MockPlayGameNotifier? mockPlayGame,
    MockContractsManager? mockContractsManager,
    MockMyStorage2? mockStorage}) {
  if (mockPlayGame == null) {
    mockPlayGame = MockPlayGameNotifier();
    mockGame(mockPlayGame);
  }
  if (mockStorage == null) {
    mockStorage = MockMyStorage2();
    mockActiveContracts(mockStorage);
  }

  final container = ProviderContainer(
    overrides: [
      playGameProvider.overrideWith((_) => mockPlayGame!),
      storageProvider.overrideWithValue(mockStorage),
      if (mockContractsManager != null)
        contractsManagerProvider.overrideWith((_) => mockContractsManager),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: ScoresByPlayer(mockPlayGame.players[0])),
  );
}
