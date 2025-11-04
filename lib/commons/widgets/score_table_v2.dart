import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../models/player.dart';
import 'player_icon.dart';

/// A table to display scores
class ScoreTableV2 extends StatelessWidget {
  /// The contracts for the game
  final List<ContractsInfo> contracts;

  /// The data to display in the body rows
  final List<ScoreRowV2> rows;

  const ScoreTableV2({super.key, required this.contracts, required this.rows});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const spanPadding = TableSpanPadding.all(4);
    final textScale = MediaQuery.of(context).textScaler.scale(1);
    return TableView.list(
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      columnBuilder: (int index) {
        final double columnWidth = index == 0
            ? 40 + (20 * textScale)
            : 70 * textScale;
        return TableSpan(
          extent: FixedTableSpanExtent(columnWidth),
          padding: spanPadding,
        );
      },
      rowBuilder: (int index) {
        final double rowHeight = index == 0
            ? 45 * textScale
            : 40 + (25 * textScale);
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
          extent: FixedTableSpanExtent(rowHeight),
          backgroundDecoration: border,
          padding: spanPadding,
        );
      },
      cells: [
        [
          TableViewCell(child: Container()),
          ...contracts.map(
            (contract) => TableViewCell(
              child: Center(child: Text(context.l10n.contractName(contract))),
            ),
          ),
          TableViewCell(
            child: Center(
              child: Text(
                context.l10n.total,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
        ...rows.map(
          (row) => row.build(textTheme.bodyMedium!, [
            ...contracts.map((c) => context.l10n.contractName(c)),
            "Total",
          ]),
        ),
      ],
    );
  }
}

/// A widget to represent the row of a table
class ScoreRowV2 {
  final Key? key;

  /// The player concerned by the row
  final Player player;

  /// The score of each player of this row. If null, displays "/" or 0 score
  final Map<String, int?>? scores;

  const ScoreRowV2({required this.player, required this.scores, this.key});

  /// Builds the cells of a row from [scores] map. The values of this map are ordered by the [orderedScoreKeys]
  List<TableViewCell> build(
    TextStyle textStyle,
    List<String> orderedScoreKeys,
  ) {
    return [
      TableViewCell(
        key: key,
        child: Tooltip(
          message: player.name,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlayerIcon(image: player.image, color: player.color, size: 40),
              Text(
                player.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      ...orderedScoreKeys.map((key) {
        final isTotal = key == "Total";
        final score = scores?[key] ?? (isTotal ? 0 : null);
        return TableViewCell(
          key: Key("${player.name}-$key"),
          child: Center(
            child: Text(
              score?.toString() ?? "/",
              style: isTotal
                  ? textStyle.copyWith(fontWeight: FontWeight.w900)
                  : textStyle,
            ),
          ),
        );
      }),
    ];
  }
}
