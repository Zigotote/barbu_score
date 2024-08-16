import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/player.dart';
import '../../../commons/notifiers/contracts_manager.dart';
import '../../../commons/notifiers/play_game.dart';
import '../../../commons/utils/contract_scores.dart';
import '../../../commons/widgets/score_table.dart';

/// A table to display the scores of players for the entire game
class GameTable extends ConsumerWidget {
  const GameTable({super.key});

  /// Builds the rows to display player scores for each contract
  List<ScoreRow> _buildPlayerRows(
      Map<ContractsInfo, Map<String, int>?> contractScores,
      List<Player> players) {
    return contractScores.entries.map((contractScore) {
      return ScoreRow(
        title: contractScore.key.displayName,
        scores: contractScore.value,
      );
    }).toList();
  }

  /// Builds the row to display total scores
  ScoreRow _buildTotalRow(Map<ContractsInfo, Map<String, int>?> contractScores,
      List<Player> players) {
    final totalScores = sumScores(contractScores.values.toList());
    return ScoreRow(
      title: "Total",
      scores: totalScores,
      isTotal: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.read(playGameProvider).players;
    final contractScores =
        ref.read(contractsManagerProvider).sumScoresByContract(players);
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ScoreTable(
            players: players,
            rows: [
              ..._buildPlayerRows(contractScores, players),
              _buildTotalRow(contractScores, players)
            ],
          ),
        ),
      ],
    );
  }
}
