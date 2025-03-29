import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_settings_models.dart';
import '../../commons/utils/constants.dart';
import '../../commons/utils/player_icon_properties.dart';
import '../../commons/widgets/player_icon.dart';
import 'notifiers/contract_settings_provider.dart';
import 'widgets/contract_settings.dart';
import 'widgets/number_input.dart';

class DominoContractSettingsPage extends ConsumerWidget {
  const DominoContractSettingsPage({super.key});

  Widget _buildDataTable(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(contractSettingsProvider(ContractsInfo.domino));
    final settings = provider.settings as DominoContractSettings;
    const spanPadding = TableSpanPadding.all(4);
    return TableView.list(
      pinnedRowCount: 1,
      pinnedColumnCount: 1,
      columnBuilder: (_) => TableSpan(
        extent: FixedTableSpanExtent(
          48 + MediaQuery.of(context).textScaler.scale(15),
        ),
        padding: spanPadding,
      ),
      rowBuilder: (_) => TableSpan(
        extent: FixedTableSpanExtent(
          40 + MediaQuery.of(context).textScaler.scale(10),
        ),
        padding: spanPadding,
      ),
      cells: [
        [
          _buildPlayersStack(),
          ...List.generate(settings.points.length, (index) {
            final nbPlayers = index + kNbPlayersMin;
            return TableViewCell(
              child: Center(
                child: Tooltip(
                  message: context.l10n.pointsForNbPlayers(nbPlayers),
                  child: Text(
                    "$nbPlayers ${context.l10n.players.substring(0, 1)}.",
                  ),
                ),
              ),
            );
          })
        ],
        ...[
          for (int position = 1; position <= kNbPlayersMax; position++)
            [
              TableViewCell(
                child: Center(
                  child: Text(context.l10n.ordinalNumber(position)),
                ),
              ),
              ..._buildPointsCells(settings, provider, position - 1),
            ]
        ]
      ],
    );
  }

  TableViewCell _buildPlayersStack() {
    return TableViewCell(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: List.generate(
          5,
          (index) {
            const double basePadding = 110;
            const double baseSize = 36;
            // Applicates a ratio to other icons than the first one
            final ratio = index == 0 ? 1 : (1 - 0.15 * (index / 2).round());
            final playerIcon = PlayerIcon(
              image: playerImages[index],
              color: playerColors[index],
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
      ),
    );
  }

  List<TableViewCell> _buildPointsCells(DominoContractSettings settings,
      ContractSettingsNotifier provider, int playerIndex) {
    return List.generate(settings.points.length, (index) {
      final int nbPlayers = index + kNbPlayersMin;
      if (playerIndex < settings.points[nbPlayers]!.length) {
        return TableViewCell(
          child: NumberInput(
            points: settings.points[nbPlayers]![playerIndex],
            onChanged: provider.modifySetting(
                (value) => settings.points[nbPlayers]?[playerIndex] = value),
          ),
        );
      }
      return TableViewCell(child: Container());
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ContractSettingsPage(
      contract: ContractsInfo.domino,
      isScrollable: false,
      children: [Flexible(child: _buildDataTable(context, ref))],
    );
  }
}
