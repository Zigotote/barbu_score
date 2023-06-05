import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/party.dart';
import '../controller/player.dart';
import '../models/contract_info.dart';
import '../widgets/my_subtitle.dart';
import '../widgets/page_layouts.dart';
import '../widgets/player_icon.dart';

/// A page to display the scores for the contracts of a player
class ScoresByPlayer extends GetView<PartyController> {
  final PlayerController player = Get.arguments as PlayerController;

  /// Builds the table to display the scores of the players in a matrix
  DataTable _buildTable(Color textColor) {
    final double headingHeight = Get.width * 0.17;
    return DataTable(
      headingRowHeight: headingHeight,
      headingTextStyle: Get.textTheme.labelLarge,
      columnSpacing: 8,
      border: TableBorder(
        horizontalInside: BorderSide(color: textColor),
      ),
      columns: [
        DataColumn(label: Text("")),
        ...controller.players
            .map(
              (player) => DataColumn(
                label: Container(
                  width: headingHeight,
                  child: Column(
                    children: [
                      PlayerIcon(
                        image: player.image,
                        color: player.color,
                        size: Get.width * 0.1,
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
              ..._buildScoresCells(player.contractScores(contract.name),
                  contract: contract),
            ],
          );
        }).toList(),
        DataRow(
          cells: [
            DataCell(Text(
              "Total",
              style: Get.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w900,
              ),
            )),
            ..._buildScoresCells(player.playerScores)
          ],
        ),
      ],
    );
  }

  /// Builds the cells to display the score of each player
  List<DataCell> _buildScoresCells(Map<String, int> playerScores,
      {ContractsInfo? contract}) {
    bool contractHasBeenPlayed = true;
    if (player.availableContracts.contains(contract)) {
      contractHasBeenPlayed = false;
    }
    return controller.players
        .map((player) => DataCell(
              Center(
                child: Text(
                  contractHasBeenPlayed
                      ? playerScores[player.name].toString()
                      : '/',
                  style: contract == null
                      ? Get.textTheme.bodyMedium!.copyWith(
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
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              MySubtitle("Contrats de ${player.name}"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildTable(Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ));
  }
}
