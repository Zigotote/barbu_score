import 'package:barbu_score/commons/widgets/score_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/models/contract_info.dart';
import '../commons/models/player.dart';
import '../commons/notifiers/play_game.dart';
import '../commons/utils/screen.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/my_subtitle.dart';
import '../commons/widgets/player_icon.dart';

/// A page to display the scores for the contracts of a player
class ScoresByPlayer extends ConsumerWidget {
  /// The player whose contract scores are shown
  final Player player;

  static final double _headingRowHeight = ScreenHelper.width * 0.17;

  const ScoresByPlayer(this.player, {super.key});

  /// Builds the widgets to display the icon and name of each player
  List<Widget> _buildColumnHeaders(List<Player> players) {
    return players
        .map(
          (player) => SizedBox(
            width: _headingRowHeight,
            child: Column(
              children: [
                PlayerIcon(
                  image: player.image,
                  color: player.color,
                  size: ScreenHelper.width * 0.1,
                ),
                Text(player.name, overflow: TextOverflow.ellipsis)
              ],
            ),
          ),
        )
        .toList();
  }

  /// Builds the rows to display player scores for each contract
  List<ScoreRow> _buildPlayerRows(List<Player> players) {
    return ContractsInfo.values.map((contract) {
      final Map<String, int>? scores = player.contractScores(contract.name);
      return ScoreRow(
        title: contract.displayName,
        scores: players.map((p) => scores?[p.name]).toList(),
      );
    }).toList();
  }

  /// Builds the row to display total scores
  ScoreRow _buildTotalRow(List<Player> players) {
    return ScoreRow(
      title: "Total",
      scores: players.map((p) => player.playerScores?[p.name]).toList(),
      isBold: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.read(playGameProvider).players;
    return DefaultPage(
      hasLeading: true,
      title: "Scores",
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            MySubtitle("Contrats de ${player.name}"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ScoreTable(
                headingRowHeight: _headingRowHeight,
                columnHeaders: _buildColumnHeaders(players),
                rows: [..._buildPlayerRows(players), _buildTotalRow(players)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
