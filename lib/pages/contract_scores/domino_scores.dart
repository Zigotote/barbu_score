import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/player.dart';
import '../../commons/notifiers/play_game.dart';
import '../../commons/widgets/colored_container.dart';
import 'widgets/contract_page.dart';

/// A page to fill the scores for a domino contract
class DominoScores extends ConsumerStatefulWidget {
  const DominoScores({super.key});

  @override
  ConsumerState<DominoScores> createState() => _DominoScoresState();
}

class _DominoScoresState extends ConsumerState<DominoScores> {
  /// The ordered list of players
  late List<Player> orderedPlayers;

  @override
  void initState() {
    super.initState();
    setState(
        () => orderedPlayers = List.from(ref.read(playGameProvider).players));
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
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
          ),
          Icon(
            Icons.drag_handle,
            color: color,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      subtitle: "Quel est l'ordre des joueurs ?",
      contract: ContractsInfo.domino,
      isValid: orderedPlayers.isNotEmpty,
      // Not really items by players, it's more player's rank
      itemsByPlayer: {
        for (var player in orderedPlayers)
          player.name: orderedPlayers.indexOf(player)
      },
      child: _buildFields(),
    );
  }
}
