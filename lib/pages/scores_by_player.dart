import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/models/contract_info.dart';
import '../commons/models/player.dart';
import '../commons/providers/contracts_manager.dart';
import '../commons/providers/log.dart';
import '../commons/providers/play_game.dart';
import '../commons/utils/contract_scores.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/my_appbar.dart';
import '../commons/widgets/my_subtitle.dart';
import '../commons/widgets/score_table.dart';

/// A page to display the scores for the contracts of a player
class ScoresByPlayer extends ConsumerWidget {
  /// The name of the player whose contract scores are shown
  final String playerName;

  const ScoresByPlayer(this.playerName, {super.key});

  /// Builds the rows to display player scores for each contract
  List<ScoreRow> _buildPlayerRows(
    BuildContext context,
    Map<ContractsInfo, Map<String, int>?> playerScores,
    List<Player> players,
  ) {
    return playerScores.entries
        .map(
          (playerScore) => ScoreRow(
            key: Key(playerScore.key.name),
            title: context.l10n.contractName(playerScore.key),
            scores: playerScore.value,
          ),
        )
        .toList();
  }

  /// Builds the row to display total scores
  ScoreRow _buildTotalRow(
    BuildContext context,
    Map<ContractsInfo, Map<String, int>?> playerScores,
    List<Player> players,
  ) {
    final totalScores = sumScores(playerScores.values.toList());
    return ScoreRow(
      title: context.l10n.total,
      scores: totalScores,
      isTotal: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(logProvider).info("ScoresByPlayer: show scores for $playerName");
    ref.read(logProvider).sendAnalyticEvent("scores_by_player");
    final players = ref.read(playGameProvider).players;
    final playerScores = ref.read(contractsManagerProvider).scoresByContract(
          players.firstWhere((player) => player.name == playerName),
        );
    return DefaultPage(
      appBar: MyAppBar(Text(context.l10n.scores), context: context),
      content: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          MySubtitle(context.l10n.contractsOf(playerName)),
          Expanded(
            child: ScoreTable(
              players: players,
              rows: [
                ..._buildPlayerRows(context, playerScores, players),
                _buildTotalRow(context, playerScores, players)
              ],
            ),
          )
        ],
      ),
    );
  }
}
