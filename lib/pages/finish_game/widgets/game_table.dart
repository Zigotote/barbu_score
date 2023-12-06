import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/player.dart';
import '../../../commons/notifiers/play_game.dart';
import '../../../commons/utils/storage.dart';
import '../../../commons/widgets/score_table.dart';

/// A table to display the scores of players for the entire game
class GameTable extends ConsumerWidget {
  const GameTable({super.key});

  /// Builds the rows to display player scores for each contract
  List<ScoreRow> _buildPlayerRows(List<Player> players) {
    return MyStorage.getActiveContracts().map((contract) {
      final Map<String, int> scores = {};
      for (var player in players) {
        final Map<String, int>? playerContractScores =
            player.contractScores(contract.name);
        _sumScores(scores, playerContractScores);
      }
      return ScoreRow(
        title: contract.displayName,
        scores: players.map((p) => scores[p.name]).toList(),
      );
    }).toList();
  }

  /// Builds the row to display total scores
  ScoreRow _buildTotalRow(List<Player> players) {
    final Map<String, int> scores = {};
    for (var player in players) {
      final Map<String, int>? playerContractScores = player.playerScores;
      _sumScores(scores, playerContractScores);
    }
    return ScoreRow(
      title: "Total",
      scores: players.map((p) => scores[p.name]).toList(),
      isBold: true,
    );
  }

  /// Sums scoresToSum to scores to get summed score for each player
  void _sumScores(Map<String, int> scores, Map<String, int>? scoresToSum) {
    scoresToSum?.forEach((playerName, score) {
      if (scores.containsKey(playerName)) {
        scores[playerName] = scores[playerName]! + score;
      } else {
        scores[playerName] = score;
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.read(playGameProvider).players;
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ScoreTable(
            players: players,
            rows: [..._buildPlayerRows(players), _buildTotalRow(players)],
          ),
        ),
      ],
    );
  }
}
