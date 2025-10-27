import 'dart:math';

import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/my_list_layouts.dart';
import '../../commons/widgets/my_subtitle.dart';
import '../../main.dart';
import 'widgets/rules_button.dart';

/// A page to fill the scores for a domino contract
class DominoContractPage extends ConsumerStatefulWidget {
  const DominoContractPage({super.key});

  @override
  ConsumerState<DominoContractPage> createState() => _DominoContractPageState();
}

class _DominoContractPageState extends ConsumerState<DominoContractPage> {
  /// The ordered list of players
  List<String> orderedPlayerNames = [];

  @override
  void initState() {
    super.initState();
  }

  /// Build player's list
  Widget _buildFields(List<Player> players) {
    final indicatorSize = MediaQuery.of(context).textScaler.scale(35);
    return MyGrid(
      children: players.map((player) {
        final isOrdered = orderedPlayerNames.contains(player.name);
        final playerRank = isOrdered
            ? (orderedPlayerNames.indexOf(player.name) + 1)
            : null;
        return ElevatedButtonWithIndicator(
          text: player.name,
          color: player.color,
          onPressed: () => setState(
            () => isOrdered
                ? orderedPlayerNames.remove(player.name)
                : orderedPlayerNames.add(player.name),
          ),
          indicator: isOrdered
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.convertMyColor(player.color),
                      width: 2,
                    ),
                  ),
                  height: indicatorSize,
                  width: indicatorSize,
                  child: Center(
                    child: Text(
                      playerRank.toString(),
                      semanticsLabel: context.l10n.ordinalNumber(playerRank!),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                )
              : null,
        );
      }).toList(),
    );
  }

  void _saveContract(BuildContext context, WidgetRef ref) {
    final contractModel = DominoContractModel(
      rankOfPlayer: {
        for (var playerName in orderedPlayerNames)
          playerName: orderedPlayerNames.indexOf(playerName),
      },
    );
    ref
        .read(logProvider)
        .info("DominoContractPage.saveContract: save $contractModel");
    final provider = ref.read(playGameProvider);
    provider.finishContract(contractModel);

    context.go(
      provider.nextPlayer() ? Routes.chooseContract : Routes.finishGame,
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playGameProvider).players;

    return MyDefaultPage(
      appBar: MyPlayerAppBar(
        player: ref.watch(playGameProvider).currentPlayer,
        context: context,
        trailing: RulesButton(ContractsInfo.domino),
      ),
      content: Column(
        spacing: 8,
        children: [
          MySubtitle(
            context.l10n.dominoScoreSubtitle(
              context.l10n.ordinalNumber(
                min(orderedPlayerNames.length + 1, players.length),
              ),
            ),
          ),
          _buildFields(players),
        ],
      ),
      bottomWidget: ElevatedButtonFullWidth(
        onPressed: players.length == orderedPlayerNames.length
            ? () => _saveContract(context, ref)
            : null,
        child: Text(context.l10n.validateScores, textAlign: TextAlign.center),
      ),
    );
  }
}
