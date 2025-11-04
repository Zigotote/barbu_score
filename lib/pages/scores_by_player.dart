import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/score_table_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/models/contract_info.dart';
import '../commons/models/player.dart';
import '../commons/providers/contracts_manager.dart';
import '../commons/providers/log.dart';
import '../commons/providers/play_game.dart';
import '../commons/utils/contract_scores.dart';
import '../commons/widgets/my_appbar.dart';
import '../commons/widgets/my_default_page.dart';
import '../commons/widgets/my_subtitle.dart';
import '../commons/widgets/score_table.dart';

/// A page to display the scores for the contracts of a player
class ScoresByPlayer extends ConsumerStatefulWidget {
  /// The name of the player whose contract scores are shown
  final String playerName;

  const ScoresByPlayer(this.playerName, {super.key});

  @override
  ConsumerState<ScoresByPlayer> createState() => _ScoresByPlayerState();
}

class _ScoresByPlayerState extends ConsumerState<ScoresByPlayer> {
  bool tmpChangeAxis = false;

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

  @override
  Widget build(BuildContext context) {
    ref
        .read(logProvider)
        .info("ScoresByPlayer: show scores for ${widget.playerName}");
    ref.read(logProvider).sendAnalyticEvent("scores_by_player");
    final players = ref.read(playGameProvider).players;
    final playerScores = ref
        .read(contractsManagerProvider)
        .scoresByContract(
          players.firstWhere((player) => player.name == widget.playerName),
        );
    return Scaffold(
      appBar: MyAppBar(Text(context.l10n.scores), context: context),
      body: SafeArea(
        child: Padding(
          padding: MyDefaultPage.appPadding,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            spacing: 24,
            children: [
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MySubtitle(context.l10n.contractsOf(widget.playerName)),
                  IconButton.outlined(
                    onPressed: () =>
                        setState(() => tmpChangeAxis = !tmpChangeAxis),
                    icon: Icon(Icons.rotate_left),
                  ),
                ],
              ),
              Expanded(
                child: tmpChangeAxis
                    ? ScoreTableV2(
                        contracts: ref
                            .read(contractsManagerProvider)
                            .activeContracts,
                        rows: _buildPlayerRowsV2(
                          context,
                          players,
                          playerScores,
                        ),
                      )
                    : ScoreTable(
                        players: players,
                        rows: [
                          ..._buildPlayerRows(context, playerScores, players),
                          _buildTotalRow(context, playerScores, players),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
