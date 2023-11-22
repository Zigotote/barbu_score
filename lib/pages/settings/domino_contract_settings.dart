import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/utils/globals.dart';
import '../../commons/utils/player_icon_properties.dart';
import '../../commons/utils/screen.dart';
import '../../commons/widgets/player_icon.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/number_input.dart';

class DominoContractSettingsPage extends ConsumerWidget {
  const DominoContractSettingsPage({super.key});

  Widget _buildDataTable(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(contractSettingsProvider(ContractsInfo.domino));
    final settings = provider.settings as DominoContractSettings;
    final List<String> positionNames = [
      "1er",
      "2ème",
      "3ème",
      "4ème",
      "5ème",
      "6ème"
    ];
    return DataTable(
      columnSpacing: 8,
      // I don't want border but it doesn't work because of https://github.com/flutter/flutter/issues/132214
      dividerThickness: 0,
      horizontalMargin: 8,
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 1,
        ),
      ),
      columns: [
        DataColumn(
          label: _buildPlayersStack(),
        ),
        ...List.generate(
          settings.points.length,
          (index) => DataColumn(
            label: Expanded(
              child: Text(
                "${index + kNbPlayersMin} j.",
                textAlign: TextAlign.center,
              ),
            ),
            tooltip: "Points à ${index + kNbPlayersMin} joueurs",
          ),
        )
      ],
      rows: positionNames.mapIndexed((index, positionName) {
        return DataRow(
          cells: [
            DataCell(Text(positionName)),
            ..._buildPointsCells(settings, provider, index),
          ],
        );
      }).toList(),
    );
  }

  Stack _buildPlayersStack() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: List.generate(
        5,
        (index) {
          final image = PlayerIconProperties.playerImages[index];
          final basePadding = ScreenHelper.width * 0.3;
          final baseSize = ScreenHelper.width * 0.1;
          // Applicates a ratio to other icons than the first one
          final ratio = index == 0 ? 1 : (1 - 0.15 * (index / 2).round());
          final playerIcon = PlayerIcon(
            image: image,
            color: PlayerIconProperties.playerColors[index],
            size: baseSize * ratio,
          );
          if (index % 2 == 0) {
            return Padding(
              padding: EdgeInsets.only(left: basePadding * (1 - ratio)),
              child: playerIcon,
            );
          }
          return Padding(
            padding: EdgeInsets.only(right: basePadding * (1 - ratio)),
            child: playerIcon,
          );
        },
      ).reversed.toList(),
    );
  }

  List<DataCell> _buildPointsCells(DominoContractSettings settings,
      ContractSettingsNotifier provider, int playerIndex) {
    return List.generate(settings.points.length, (index) {
      final int nbPlayers = index + kNbPlayersMin;
      if (playerIndex < settings.points[nbPlayers]!.length) {
        return DataCell(
          NumberInput(
              points: settings.points[nbPlayers]![playerIndex],
              onChanged: provider.modifySetting(
                  (value) => settings.points[nbPlayers]?[playerIndex] = value)),
        );
      }
      return DataCell(Container());
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContractSettingsPage(
      contract: ContractsInfo.domino,
      children: [_buildDataTable(context, ref)],
    );
  }
}
