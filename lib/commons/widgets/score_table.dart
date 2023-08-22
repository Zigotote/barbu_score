import 'package:flutter/material.dart';

import '../utils/screen.dart';

/// A table to display scores
class ScoreTable extends StatelessWidget {
  /// The name of the columns of the table
  final List<Widget> columnHeaders;

  /// The data to display in the body rows
  final List<ScoreRow> rows;

  /// The height of the heading row. If null, defaults to DataTable headingRowHeight value
  final double? headingRowHeight;

  const ScoreTable(
      {super.key,
      required this.columnHeaders,
      required this.rows,
      this.headingRowHeight});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DataTable(
      headingRowHeight: headingRowHeight,
      headingTextStyle: textTheme.labelLarge,
      columnSpacing: 8,
      border: TableBorder(
        horizontalInside: BorderSide(color: textColor),
      ),
      columns: [
        const DataColumn(label: Text("")),
        ...columnHeaders
            .map((header) => DataColumn(label: header, numeric: true))
            .toList()
      ],
      rows: [
        ...rows.map((row) {
          return row.build(textTheme.bodyMedium!);
        }).toList(),
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
        DataCell(Text(title)),
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
            .toList()
      ],
    );
  }
}
