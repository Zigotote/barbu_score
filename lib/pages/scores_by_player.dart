import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../models/contract_names.dart';
import '../widgets/page_layouts.dart';
import '../widgets/player_icon.dart';

/// A page to display the scores for the contracts of a player
class ScoresByPlayer extends GetView<PartyController> {
  final PlayerController player = Get.arguments as PlayerController;

  /// Builds the subtitle of the page
  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Get.height * 0.04,
      ),
      child: Center(
        child: Text(
          "Contrats de ${player.name}",
          style: Get.textTheme.subtitle2,
        ),
      ),
    );
  }

  /// Builds the table to display the scores of the players in a matrix
  DataTable _buildTable() {
    return DataTable(
      columnSpacing: 8,
      columns: [
        DataColumn(label: Text("")),
        ...controller.players
            .map((player) => DataColumn(
                  label: PlayerIcon(
                    image: player.image,
                    color: player.color,
                    size: Get.width * 0.1,
                  ),
                  numeric: true,
                ))
            .toList()
      ],
      rows: [
        ...ContractsNames.values
            .map(
              (contractName) => DataRow(
                cells: [
                  DataCell(Text(contractName.displayName)),
                  ..._buildScoresCells(player.contractScores(contractName)),
                ],
              ),
            )
            .toList(),
        DataRow(
          cells: [
            DataCell(Text(
              "Total",
              style: Get.textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.w900,
              ),
            )),
            ..._buildScoresCells(player.playerScores, isBold: true)
          ],
        ),
      ],
    );
  }

  /// Builds the cells to display the score of each player
  List<DataCell> _buildScoresCells(Map<PlayerController, int> playerScores,
      {bool isBold = false}) {
    return controller.players
        .map((player) => DataCell(
              Center(
                child: Text(
                  playerScores[player].toString(),
                  style: isBold
                      ? Get.textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w900,
                        )
                      : null,
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      hasLeading: true,
      title: "Scores",
      content: Column(
        children: [
          _buildSubtitle(),
          SingleChildScrollView(
            child: _buildTable(),
            scrollDirection: Axis.horizontal,
          ),
        ],
      ),
    );
  }
}
