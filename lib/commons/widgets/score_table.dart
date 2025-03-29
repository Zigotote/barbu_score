import 'dart:math';

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
  List<TableViewCell> _buildPlayersRow() {
    return players
        .map(
          (player) => TableViewCell(
            child: Tooltip(
              message: player.name,
              child: Column(
                children: [
                  PlayerIcon(
                    image: player.image,
                    color: player.color,
                    size: 40,
                  ),
                  Text(
                    player.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const spanPadding = TableSpanPadding.all(4);
    final textScale = MediaQuery.of(context).textScaler.scale(1);
    double playerColumnWidth = 50 * textScale;
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
                if (leftSpaceInScreen > 110 * textScale) {
                  playerColumnWidth = 70 * textScale;
                  leftSpaceInScreen =
                      remainingSpace - playerColumnWidth * players.length - 32;
                }
                // Column width cannot be less than 70 pixels
                return max(70 * textScale, leftSpaceInScreen);
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
        final double rowWidth =
            index == 0 ? 40 + (20 * textScale) : 45 * textScale;
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
        [TableViewCell(child: Container()), ..._buildPlayersRow()],
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
  final Key? key;

  /// The title of the row
  final String title;

  /// The score of each player of this row. If null, displays "/" or 0 score
  final Map<String, int?>? scores;

  /// The indicator to know if this line is the final line
  final bool isTotal;

  const ScoreRow({
    required this.title,
    required this.scores,
    this.isTotal = false,
    this.key,
  });

  /// Builds the cells of a row from [scores] map. The values of this map are ordered by the [orderedScoreKeys]
  List<TableViewCell> build(
      TextStyle textStyle, List<String> orderedScoreKeys) {
    return [
      TableViewCell(
        key: key,
        child: Center(
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
      ),
      ...orderedScoreKeys.map(
        (key) {
          final score = scores?[key] ?? (isTotal ? 0 : null);
          return TableViewCell(
            key: Key("$title-$key"),
            child: Center(
              child: Text(
                score != null ? score.toString() : "/",
                style: isTotal
                    ? textStyle.copyWith(
                        fontWeight: FontWeight.w900,
                      )
                    : textStyle,
              ),
            ),
          );
        },
      ),
    ];
  }
}
