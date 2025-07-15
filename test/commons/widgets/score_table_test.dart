import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:barbu_score/commons/widgets/score_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/utils.dart';

void main() {
  final players = List.generate(
    4,
    (index) => Player(
      name: defaultPlayerNames[index],
      color: PlayerColors.values[index],
      image: playerImages[index],
      contracts: [],
    ),
  );
  const title = "Title";

  patrolWidgetTest("should display scores by contract in the great order",
      ($) async {
    $.tester.view.physicalSize = const Size(1440, 2560);
    await $.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScoreTable(
            players: players,
            rows: [
              ScoreRow(
                title: title,
                scores: {
                  for (var (index, player) in players.reversed.indexed)
                    player.name: index * 10
                },
              ),
            ],
          ),
        ),
      ),
    );

    _verifyScorePositionInTable(
      $,
      scoreTitle: title,
      playerIndexes: [3],
      score: "0",
    );

    _verifyScorePositionInTable(
      $,
      scoreTitle: title,
      playerIndexes: [2],
      score: "10",
    );

    _verifyScorePositionInTable(
      $,
      scoreTitle: title,
      playerIndexes: [1],
      score: "20",
    );

    _verifyScorePositionInTable(
      $,
      scoreTitle: title,
      playerIndexes: [0],
      score: "30",
    );
    expect(($("/")), findsNothing);
  });
  for (var isTotal in [true, false]) {
    patrolWidgetTest(
        "should display ${isTotal ? "zero" : "empty symbol"} if no scores for contract",
        ($) async {
      $.tester.view.physicalSize = const Size(1440, 2560);
      await $.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScoreTable(
              players: players,
              rows: [
                ScoreRow(
                  title: title,
                  isTotal: isTotal,
                  scores: null,
                ),
              ],
            ),
          ),
        ),
      );

      _verifyScorePositionInTable(
        $,
        scoreTitle: title,
        playerIndexes:
            players.indexed.map((indexedPlayer) => indexedPlayer.$1).toList(),
        score: isTotal ? "0" : "/",
        nbScores: players.length,
      );
    });
  }
}

void _verifyScorePositionInTable(PatrolTester $,
    {required String scoreTitle,
    required List<int> playerIndexes,
    required String score,
    int nbScores = 1}) {
  for (var playerIndex in playerIndexes) {
    expect(
        ($(Key("$scoreTitle-${defaultPlayerNames[playerIndex]}"))).containing(
          $(score),
        ),
        findsOneWidget);
  }
  expect($(score), findsNWidgets(nbScores));
}
