import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/player.dart';
import '../../commons/notifiers/play_game.dart';
import '../../commons/utils/screen.dart';
import '../../commons/widgets/colored_container.dart';
import 'widgets/contract_page.dart';

/// A page to fill the scores for a domino contract
class DominoScores extends ConsumerStatefulWidget {
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
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      itemCount: orderedPlayers.length,
      itemBuilder: (_, index) {
        Player player = orderedPlayers[index];
        return ReorderableDragStartListener(
          key: ValueKey(index),
          index: index,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  (index + 1).toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ColoredContainer(
                  height: ScreenHelper.height * 0.08,
                  width: ScreenHelper.width * 0.75,
                  color: player.color,
                  child: _buildPlayerTile(player),
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
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            player.name,
            style: TextStyle(
              fontSize: 16,
              color: player.color,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Icon(
            Icons.drag_handle,
            color: player.color,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      subtitle: "Quel est l'ordre des joueurs ?",
      contract: ContractsInfo.Domino,
      isValid: orderedPlayers.length > 0,
      // Not really items by players, it's more player's rank
      itemsByPlayer: Map.fromIterable(
        this.orderedPlayers,
        key: (player) => player.name,
        value: (player) => this.orderedPlayers.indexOf(player),
      ),
      child: _buildFields(),
    );
  }
}
