import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/contract_info.dart';
import '../../../commons/models/player.dart';
import '../../../commons/providers/contracts_manager.dart';
import '../../../commons/providers/play_game.dart';
import '../../../commons/utils/contract_scores.dart';
import '../../../commons/widgets/score_table.dart';
import '../../../commons/widgets/score_table_v2.dart';

/// A table to display the scores of players for the entire game
class GameTable extends ConsumerStatefulWidget {
  const GameTable({super.key});

  @override
  ConsumerState<GameTable> createState() => _GameTableState();
}

class _GameTableState extends ConsumerState<GameTable> {
  bool tmpChangeAxis = false;

  /// Builds the rows to display player scores for each contract
  List<ScoreRow> _buildPlayerRows(
    BuildContext context,
    Map<ContractsInfo, Map<String, int>?> contractScores,
    List<Player> players,
  ) {
    return contractScores.entries.map((contractScore) {
      return ScoreRow(
        title: context.l10n.contractName(contractScore.key),
        scores: contractScore.value,
      );
    }).toList();
  }

  /// Builds the rows to display player scores for each contract
  List<ScoreRowV2> _buildPlayerRowsV2(
    BuildContext context,
    List<Player> players,
    Map<ContractsInfo, Map<String, int>?> contractScores,
  ) {
    return players.map((player) {
      int total = 0;
      final playerScores = Map.fromEntries(
        contractScores.entries.map((contractScore) {
          total += contractScore.value?[player.name] ?? 0;
          return MapEntry(
            context.l10n.contractName(contractScore.key),
            contractScore.value?[player.name],
          );
        }),
      );
      return ScoreRowV2(
        key: Key(player.name),
        player: player,
        scores: {...playerScores, "Total": total},
      );
    }).toList();
  }

  /// Builds the row to display total scores
  ScoreRow _buildTotalRow(
    BuildContext context,
    Map<ContractsInfo, Map<String, int>?> contractScores,
    List<Player> players,
  ) {
    final totalScores = sumScores(contractScores.values.toList());
    return ScoreRow(
      title: context.l10n.total,
      scores: totalScores,
      isTotal: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.read(playGameProvider).players;
    final contractScores = ref
        .read(contractsManagerProvider)
        .sumScoresByContract(players);
    return GestureDetector(
      onLongPress: () => setState(() => tmpChangeAxis = !tmpChangeAxis),
      child: tmpChangeAxis
          ? ScoreTableV2(
              contracts: ref.read(contractsManagerProvider).activeContracts,
              rows: _buildPlayerRowsV2(context, players, contractScores),
            )
          : ScoreTable(
              players: players,
              rows: [
                ..._buildPlayerRows(context, contractScores, players),
                _buildTotalRow(context, contractScores, players),
              ],
            ),
    );
  }
}
