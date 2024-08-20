import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../models/player.dart';
import 'player_icon.dart';

/// A table to display scores
class ScoreTable extends StatelessWidget {
  /// The players for the game
  final List<Player> players;

  /// The data to display in the body rows
  final List<ScoreRow> rows;

  const ScoreTable({super.key, required this.players, required this.rows});

  /// Builds the widgets to display the icon and name of each player
  List<Widget> _buildPlayersRow() {
    return players
        .map(
          (player) => Tooltip(
            message: player.name,
            child: Column(
              children: [
                PlayerIcon(
                  image: player.image,
                  color: player.color,
                  size: 40,
                ),
                Text(player.name, overflow: TextOverflow.ellipsis)
              ],
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const spanPadding = TableSpanPadding.all(4);
    double playerColumnWidth = 60;
    return TableView.list(
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      columnBuilder: (int index) {
        if (index == 0) {
          return TableSpan(
            extent: CombiningTableSpanExtent(
              const RemainingTableSpanExtent(),
              FixedTableSpanExtent(playerColumnWidth * players.length),
              (remainingSpace, playerSpace) {
                double leftSpaceInScreen = remainingSpace - playerSpace - 32;
                // If left space in screen is too big, playerColumnWidth is increased and leftSpace is calculated again
                if (leftSpaceInScreen > 110) {
                  playerColumnWidth = 80;
                  leftSpaceInScreen =
                      remainingSpace - playerColumnWidth * players.length - 32;
                }
                // Column width cannot be less than 70 pixels
                return leftSpaceInScreen < 70 ? 70 : leftSpaceInScreen;
              },
            ),
            padding: spanPadding,
          );
        }
        return TableSpan(
          extent: FixedTableSpanExtent(playerColumnWidth),
          padding: spanPadding,
        );
      },
      rowBuilder: (int index) {
        final double rowWidth = index == 0 ? 60 : 40;
        final border = index == 0
            ? null
            : TableSpanDecoration(
                border: TableSpanBorder(
                  leading: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
        return TableSpan(
          extent: FixedTableSpanExtent(rowWidth),
          backgroundDecoration: border,
          padding: spanPadding,
        );
      },
      cells: [
        [Container(), ..._buildPlayersRow()],
        ...rows.map(
          (row) => row.build(
            textTheme.bodyMedium!,
            players.map((player) => player.name).toList(),
          ),
        )
      ],
    );
  }
}

/// A widget to represent the row of a table
class ScoreRow {
  /// The title of the row
  final String title;

  /// The score of each player of this row. If null, displays "/" or 0 score
  final Map<String, int?>? scores;

  /// The indicator to know if this line is the final line
  final bool isTotal;

  const ScoreRow(
      {required this.title, required this.scores, this.isTotal = false});

  /// Builds the cells of a row from [scores] map. The values of this map are ordered by the [orderedScoreKeys]
  List<Widget> build(TextStyle textStyle, List<String> orderedScoreKeys) {
    return [
      Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: isTotal
              ? textStyle.copyWith(
                  fontWeight: FontWeight.w900,
                )
              : textStyle,
        ),
      ),
      ...orderedScoreKeys.map(
        (key) {
          final score = scores?[key] ?? (isTotal ? 0 : null);
          return Center(
            child: Text(
              score != null ? score.toString() : "/",
              key: Key("$title-$key"),
              style: isTotal
                  ? textStyle.copyWith(
                      fontWeight: FontWeight.w900,
                    )
                  : textStyle,
            ),
          );
        },
      ),
    ];
  }
}
