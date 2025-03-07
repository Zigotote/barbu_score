import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/contracts_manager.dart';
import '../../commons/providers/log.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/utils/snackbar.dart';
import '../../commons/widgets/colored_container.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_subtitle.dart';
import '../../main.dart';

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

  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      itemCount: orderedPlayers.length,
      itemBuilder: (_, index) {
        Player player = orderedPlayers[index];
        return ReorderableDragStartListener(
          key: ValueKey(index),
          index: index,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  (index + 1).toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: ColoredContainer(
                    color: player.color,
                    child: Center(child: _buildPlayerTile(player)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        _movePlayer(oldIndex, newIndex);
      },
    );
  }

  /// Builds a stack with the name of a player and a drag icon as a leading
  Widget _buildPlayerTile(Player player) {
    final color =
        Theme.of(context).colorScheme.convertPlayerColor(player.color);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              player.name,
              style: TextStyle(color: color),
            ),
          ),
          Icon(Icons.drag_handle, color: color)
        ],
      ),
    );
  }

  _saveContract(BuildContext context, WidgetRef ref) {
    final contractModel = (ref
        .read(contractsManagerProvider)
        .getContractManager(ContractsInfo.domino)
        .model as DominoContractModel);
    final bool isFinished = contractModel.setRankOfPlayer({
      for (var player in orderedPlayers)
        player.name: orderedPlayers.indexOf(player)
    });
    ref
        .read(logProvider)
        .info("DominoContractPage.saveContract: save $contractModel");
    final provider = ref.read(playGameProvider);
    provider.finishContract(contractModel);

    if (isFinished) {
      SnackBarUtils.instance.closeSnackBar(context);
      Navigator.of(context).popAndPushNamed(
          provider.nextPlayer() ? Routes.chooseContract : Routes.finishGame);
    } else {
      SnackBarUtils.instance.openSnackBar(
        context: context,
        title: context.l10n.scoresNotValid,
        text: context.l10n.errorDomino,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      appBar: MyAppBar(
        context.l10n.playerTurn(ref.read(playGameProvider).currentPlayer.name),
        context: context,
        hasLeading: true,
      ),
      content: Column(
        spacing: 8,
        children: [
          MySubtitle(context.l10n.dominoScoreSubtitle),
          Expanded(child: _buildFields()),
        ],
      ),
      bottomWidget: ElevatedButton(
        onPressed: () => _saveContract(context, ref),
        child: Text(context.l10n.validateScores),
      ),
    );
  }
}
