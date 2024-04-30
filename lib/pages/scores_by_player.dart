import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/models/contract_info.dart';
import '../commons/models/player.dart';
import '../commons/notifiers/contracts_manager.dart';
import '../commons/notifiers/play_game.dart';
import '../commons/utils/contract_scores.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/my_subtitle.dart';
import '../commons/widgets/score_table.dart';

/// A page to display the scores for the contracts of a player
class ScoresByPlayer extends ConsumerWidget {
  /// The player whose contract scores are shown
  final Player player;

  const ScoresByPlayer(this.player, {super.key});

  /// Builds the rows to display player scores for each contract
  List<ScoreRow> _buildPlayerRows(
      Map<ContractsInfo, Map<String, int>?> playerScores,
      List<Player> players) {
    return playerScores.entries
        .map(
          (playerScore) => ScoreRow(
            title: playerScore.key.displayName,
            scores: players.map((p) => playerScore.value?[p.name]).toList(),
          ),
        )
        .toList();
  }

  /// Builds the row to display total scores
  ScoreRow _buildTotalRow(Map<ContractsInfo, Map<String, int>?> playerScores,
      List<Player> players) {
    final totalScores = sumScores(playerScores.values.toList());
    return ScoreRow(
      title: "Total",
      scores: players.map((p) => totalScores?[p.name]).toList(),
      isBold: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.read(playGameProvider).players;
    final playerScores =
        ref.read(contractsManagerProvider).scoresByContract(player);
    return DefaultPage(
      hasLeading: true,
      title: "Scores",
      content: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          MySubtitle("Contrats de ${player.name}"),
          Expanded(
            child: ScoreTable(
              players: players,
              rows: [
                ..._buildPlayerRows(playerScores, players),
                _buildTotalRow(playerScores, players)
              ],
            ),
          )
        ],
      ),
    );
  }
}
