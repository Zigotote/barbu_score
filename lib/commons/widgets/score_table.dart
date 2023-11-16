import 'package:flutter/material.dart';

import '../models/player.dart';
import '../utils/screen.dart';
import 'player_icon.dart';

/// A table to display scores
class ScoreTable extends StatelessWidget {
  /// The players for the game
  final List<Player> players;

  /// The data to display in the body rows
  final List<ScoreRow> rows;

  const ScoreTable({super.key, required this.players, required this.rows});

  /// Builds the widgets to display the icon and name of each player
  List<DataColumn> _buildPlayersRow(double headingRowHeight) {
    return players
        .map(
          (player) => DataColumn(
            label: SizedBox(
              width: headingRowHeight,
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
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final double headingRowHeight = ScreenHelper.width * 0.17;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DataTable(
      headingRowHeight: headingRowHeight,
      headingTextStyle: textTheme.labelLarge,
      columnSpacing: 8,
      columns: [
        const DataColumn(label: Text("")),
        ..._buildPlayersRow(headingRowHeight)
      ],
      rows: [
        ...rows.map((row) {
          return row.build(textTheme.bodyMedium!);
        }),
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

  DataRow build(TextStyle textStyle) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            title,
            style: isBold
                ? textStyle.copyWith(
                    fontWeight: FontWeight.w900,
                  )
                : textStyle,
          ),
        ),
        ...scores
            .map(
              (score) => DataCell(
                Center(
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
            )
            
      ],
    );
  }
}
