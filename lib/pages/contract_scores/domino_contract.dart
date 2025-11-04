import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/utils/snackbar.dart';
import '../../commons/widgets/colored_container.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
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
  late List<Player> orderedPlayers;

  @override
  void initState() {
    super.initState();
    orderedPlayers = List.from(ref.read(playGameProvider).players);
  }

  /// Moves a player from oldIndex to newIndex
  void _movePlayer(int oldIndex, int newIndex) {
    setState(() {
      Player player = orderedPlayers.removeAt(oldIndex);
      orderedPlayers.insert(newIndex, player);
    });
  }

  /// Build an orderdable player's list
  Widget _buildFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double childAspectRatio = 3;
        final shouldHaveMultipleColumns =
            MediaQuery.of(context).textScaler.scale(60) *
                orderedPlayers.length >
            constraints.minHeight;
        if (!shouldHaveMultipleColumns) {
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            childAspectRatio =
                constraints.minHeight /
                MediaQuery.of(context).textScaler.scale(20);
          } else {
            childAspectRatio =
                constraints.minHeight /
                MediaQuery.of(context).textScaler.scale(60);
          }
        }
        return ReorderableGridView.count(
          shrinkWrap: true,
          dragStartDelay: kPressTimeout,
          crossAxisCount: shouldHaveMultipleColumns
              ? MediaQuery.of(context).orientation == Orientation.landscape
                    ? 4
                    : 2
              : 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 40,
          childAspectRatio: childAspectRatio,
          onReorder: (int oldIndex, int newIndex) {
            _movePlayer(oldIndex, newIndex);
          },
          children: orderedPlayers
              .mapIndexed(
                (index, player) => Row(
                  key: ValueKey(index),
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(
                        context,
                      ).textScaler.scale(orderedPlayers.length >= 10 ? 24 : 12),
                      child: Text(
                        (index + 1).toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: ColoredContainer(
                        color: player.color,
                        child: Center(child: _buildPlayerTile(player)),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        );
      },
    );
  }

  /// Builds a stack with the name of a player and a drag icon as a leading
  Widget _buildPlayerTile(Player player) {
    final color = Theme.of(context).colorScheme.convertMyColor(player.color);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              player.name,
              style: TextStyle(color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.drag_handle, color: color),
        ],
      ),
    );
  }

  void _saveContract(BuildContext context, WidgetRef ref) {
    final contractModel = DominoContractModel(
      rankOfPlayer: {
        for (var player in orderedPlayers)
          player.name: orderedPlayers.indexOf(player),
      },
    );
    ref
        .read(logProvider)
        .info("DominoContractPage.saveContract: save $contractModel");
    final provider = ref.read(playGameProvider);
    provider.finishContract(contractModel);

    SnackBarUtils.instance.closeSnackBar(context);
    context.go(
      provider.nextPlayer() ? Routes.chooseContract : Routes.finishGame,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyDefaultPage(
      appBar: MyPlayerAppBar(
        player: ref.watch(playGameProvider).currentPlayer,
        context: context,
        trailing: RulesButton(ContractsInfo.domino),
      ),
      content: Column(
        spacing: MyDefaultPage.appPadding.top,
        children: [
          MySubtitle(context.l10n.dominoScoreSubtitle),
          _buildFields(),
        ],
      ),
      bottomWidget: ElevatedButtonFullWidth(
        onPressed: () => _saveContract(context, ref),
        child: Text(context.l10n.validateScores, textAlign: TextAlign.center),
      ),
    );
  }
}
