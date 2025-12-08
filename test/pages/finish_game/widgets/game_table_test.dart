import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/providers/contracts_manager.dart';
import 'package:barbu_score/commons/providers/log.dart';
import 'package:barbu_score/commons/providers/play_game.dart';
import 'package:barbu_score/pages/finish_game/widgets/game_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../utils/french_material_app.dart';
import '../../../utils/utils.dart';
import '../../../utils/utils.mocks.dart';

void main() {
  patrolWidgetTest("should display scores by contract", ($) async {
    final mockPlayGame = mockPlayGameNotifier();
    final game = mockPlayGame.game;
    final mockContractManager = MockContractsManager();
    when(mockContractManager.sumScoresByContract(game.players)).thenReturn({
      ContractsInfo.barbu: {
        for (var (index, player) in game.players.indexed)
          player.name: index == 0 ? 50 : 0,
      },
      ContractsInfo.noHearts: {
        for (var player in game.players) player.name: 15,
      },
      ContractsInfo.noQueens: {
        for (var player in game.players) player.name: 20,
      },
      ContractsInfo.noTricks: {
        for (var (index, player) in game.players.indexed)
          player.name: index % 2 == 0 ? 10 : 0,
      },
      ContractsInfo.noLastTrick: {
        for (var (index, player) in game.players.indexed)
          player.name: index == 0 ? 40 : 0,
      },
      ContractsInfo.salad: {for (var player in game.players) player.name: 0},
      ContractsInfo.domino: {
        for (var (index, player) in game.players.indexed)
          player.name: -10 * index,
      },
    });

    await $.pumpWidget(
      _createPage(
        $,
        mockPlayGame: mockPlayGame,
        mockContractsManager: mockContractManager,
      ),
    );

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
      findsNWidgets(
        (game.players.length - 1) *
                2 // barbu and no last trick
                +
            (game.players.length / 2)
                .round() // no tricks
                +
            1 // domino
            +
            game.players.length, // salad
      ),
    );
    // Empty lines
    expect(($("/")), findsNothing);
    // Total
    expect($("135"), findsOneWidget);
    expect($("25"), findsNWidgets(2));
    expect($("5"), findsOneWidget);
  });
}

Widget _createPage(
  PatrolTester $, {
  required MockPlayGameNotifier mockPlayGame,
  required MockContractsManager mockContractsManager,
}) {
  // Make screen bigger to avoid scrolling
  $.tester.view.physicalSize = const Size(1440, 2560);

  final container = ProviderContainer(
    overrides: [
      contractsManagerProvider.overrideWith((_) => mockContractsManager),
      logProvider.overrideWithValue(MockMyLog()),
      playGameProvider.overrideWith((_) => mockPlayGame),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: FrenchMaterialApp(home: Scaffold(body: GameTable())),
  );
}
