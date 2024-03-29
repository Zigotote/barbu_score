import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/player.dart';
import '../../commons/notifiers/play_game.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/list_layouts.dart';
import 'models/contract_route_argument.dart';
import 'widgets/contract_page.dart';

/// A page to fill the scores for a contract where only one player can loose
class OneLooserContractScores extends ConsumerStatefulWidget {
  /// The contract the player choose and the previous values, if it needs to be modified
  final ContractRouteArgument routeArgument;

  const OneLooserContractScores(this.routeArgument, {super.key});

  @override
  ConsumerState<OneLooserContractScores> createState() =>
      _OneLooserContractScoresState();
}

class _OneLooserContractScoresState
    extends ConsumerState<OneLooserContractScores> {
  /// The selected player
  Player? _selectedPlayer;

  /// The players of the game
  late final List<Player> _players;

  /// The selected player has 1 item, other have 0
  late Map<String, int> _itemsByPlayer;

  @override
  initState() {
    super.initState();
    _players = ref.read(playGameProvider).players;
    if (widget.routeArgument.isForModification) {
      String playerNameWithItem = widget
          .routeArgument.contractValues!.playerItems.entries
          .firstWhere((player) => player.value == 1)
          .key;
      _selectedPlayer =
          _players.firstWhere((player) => player.name == playerNameWithItem);
      _itemsByPlayer = widget.routeArgument.contractValues!.playerItems;
    } else {
      _itemsByPlayer = {
        for (var player in ref.read(playGameProvider).players) player.name: 0
      };
    }
  }

  /// Selects the given player
  _selectPlayer(Player player) {
    setState(() {
      _itemsByPlayer.updateAll((_, __) => 0);
      _selectedPlayer = player;
      _itemsByPlayer[player.name] = 1;
    });
  }

  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields() {
    return MyGrid(
      children: _players.map(
        (player) {
          final isPlayerSelected = _selectedPlayer == player;
          return ElevatedButtonCustomColor.player(
            text: player.name,
            color: isPlayerSelected ? null : player.color,
            onPressed: () => _selectPlayer(player),
            backgroundColor: isPlayerSelected ? player.color : null,
          );
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      subtitle:
          "Qui a remporté le ${widget.routeArgument.contractInfo.displayName} ?",
      contract: widget.routeArgument.contractInfo,
      isModification: widget.routeArgument.isForModification,
      isValid: _selectedPlayer != null,
      itemsByPlayer: _itemsByPlayer,
      child: _buildFields(),
    );
  }
}
