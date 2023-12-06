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
    return TableView.list(
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      columnBuilder: (int index) {
        const playerColumnWidth = FixedTableSpanExtent(60);
        if (index == 0) {
          return TableSpan(
            extent: CombiningTableSpanExtent(
              const RemainingTableSpanExtent(),
              playerColumnWidth,
              (remainingSpace, playerSpace) {
                final leftSpaceInScreen =
                    remainingSpace - playerSpace * players.length - 32;
                return leftSpaceInScreen < 70 ? 70 : leftSpaceInScreen;
              },
            ),
            padding: spanPadding,
          );
        }
        return const TableSpan(
          extent: playerColumnWidth,
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
        ...rows.map((row) {
          return row.build(textTheme.bodyMedium!);
        })
      ],
    );
  }
}

/// A widget to represent the row of a table
class ScoreRow {
  /// The title of the row
  final String title;

  /// The scores of this row
  final List<int?> scores;

  /// The indicator to know if the data should be in bold font or not
  final bool isBold;

  const ScoreRow(
      {required this.title, required this.scores, this.isBold = false});

  List<Widget> build(TextStyle textStyle) {
    return [
      Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: isBold
              ? textStyle.copyWith(
                  fontWeight: FontWeight.w900,
                )
              : textStyle,
        ),
      ),
      ...scores.map(
        (score) => Center(
          child: Text(
            score != null ? score.toString() : '/',
            style: isBold
                ? textStyle.copyWith(
                    fontWeight: FontWeight.w900,
                  )
                : textStyle,
          ),
        ),
      ),
    ];
  }
}
