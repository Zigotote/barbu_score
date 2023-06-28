import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/player.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/list_layouts.dart';
import '../models/contract_info.dart';
import '../notifiers/play_game.dart';
import 'widgets/contract_page.dart';

/// A page to fill the scores for a contract where only one player can loose
class OneLooserContractScores extends ConsumerStatefulWidget {
  /// The contract the player choose
  final ContractsInfo contract;

  OneLooserContractScores(this.contract);

  @override
  ConsumerState<OneLooserContractScores> createState() =>
      _OneLooserContractScoresState();
}

class _OneLooserContractScoresState
    extends ConsumerState<OneLooserContractScores> {
  /// The selected player
  Player? _selectedPlayer;

  /// The selected player has 1 item, other have 0
  late Map<String, int> _itemsByPlayer;

  @override
  initState() {
    super.initState();
    setState(() {
      _itemsByPlayer = Map.fromIterable(
        ref.read(playGameProvider).players,
        key: (player) => player.name,
        value: (_) => 0,
      );
    });
  }

  /// Selects the given player
  _selectPlayer(Player player) {
    setState(() {
      _selectedPlayer = player;
      _itemsByPlayer[player.name] = 1;
    });
  }

  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields(List<Player> players) {
    final Color defaultTextColor = Theme.of(context).scaffoldBackgroundColor;
    return MyGrid(
      children: players.map(
        (player) {
          Color playerColor = player.color;
          bool isPlayerSelected = _selectedPlayer == player;
          return ElevatedButtonCustomColor(
            text: player.name,
            color: isPlayerSelected ? defaultTextColor : playerColor,
            onPressed: () => _selectPlayer(player),
            backgroundColor: isPlayerSelected ? playerColor : null,
          );
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.read(playGameProvider).players;
    return ContractPage(
      subtitle: "Qui a remporté le ${widget.contract.displayName} ?",
      contract: widget.contract,
      isValid: _selectedPlayer != null,
      itemsByPlayer: _itemsByPlayer,
      child: _buildFields(players),
    );
  }
}
