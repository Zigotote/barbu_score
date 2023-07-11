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

  const ScoresByPlayer(this.player, {super.key});

  /// Builds the table to display the scores of the players in a matrix
  DataTable _buildTable(BuildContext context, List<Player> players) {
    final double headingHeight = ScreenHelper.width * 0.17;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DataTable(
      headingRowHeight: headingHeight,
      headingTextStyle: textTheme.labelLarge,
      columnSpacing: 8,
      border: TableBorder(
        horizontalInside: BorderSide(color: textColor),
      ),
      columns: [
        const DataColumn(label: Text("")),
        ...players
            .map(
              (player) => DataColumn(
                label: SizedBox(
                  width: headingHeight,
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
                numeric: true,
                tooltip: player.name,
              ),
            )
            .toList()
      ],
      rows: [
        ...ContractsInfo.values.map((contract) {
          return DataRow(
            cells: [
              DataCell(Text(contract.displayName)),
              ..._buildScoresCells(
                players,
                player.contractScores(contract.name),
              ),
            ],
          );
        }).toList(),
        DataRow(
          cells: [
            DataCell(Text(
              "Total",
              style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w900,
              ),
            )),
            ..._buildScoresCells(
              players,
              player.playerScores,
              textStyle: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
      ],
    );
  }

  /// Builds the cells to display the score of each player
  List<DataCell> _buildScoresCells(
      List<Player> players, Map<String, int>? playerScores,
      {TextStyle? textStyle}) {
    return players
        .map(
          (player) => DataCell(
            Center(
              child: Text(
                playerScores != null
                    ? playerScores[player.name].toString()
                    : '/',
                style: textStyle,
              ),
            ),
          ),
        )
        .toList();
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
              child: _buildTable(context, players),
            ),
          ],
        ),
      ),
    );
  }
}
