import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/contracts_manager.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/list_layouts.dart';
import 'models/contract_route_argument.dart';
import 'widgets/contract_page.dart';

/// A page to fill the scores for a contract where only one player can loose
class OneLooserContractPage extends ConsumerStatefulWidget {
  /// The contract the player choose and the previous values, if it needs to be modified
  final ContractRouteArgument routeArgument;

  const OneLooserContractPage(this.routeArgument, {super.key});

  @override
  ConsumerState<OneLooserContractPage> createState() =>
      _OneLooserContractPageState();
}

class _OneLooserContractPageState extends ConsumerState<OneLooserContractPage> {
  /// The selected player
  Player? _selectedPlayer;

  /// The players of the game
  late final List<Player> _players;

  /// The model of the contract
  late final OneLooserContractModel contractModel;

  @override
  initState() {
    super.initState();
    _players = ref.read(playGameProvider).players;
    if (widget.routeArgument.isForModification) {
      contractModel =
          widget.routeArgument.contractModel as OneLooserContractModel;
      final String playerNameWithItem = contractModel.itemsByPlayer.entries
          .firstWhere((player) => player.value == 1)
          .key;
      _selectedPlayer =
          _players.firstWhere((player) => player.name == playerNameWithItem);
    } else {
      contractModel = ref
          .read(contractsManagerProvider)
          .getContractManager(widget.routeArgument.contractInfo)
          .model as OneLooserContractModel;
    }
  }

  /// Selects the given player
  _selectPlayer(Player player) {
    setState(() {
      _selectedPlayer = player;
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
    final players = ref.read(playGameProvider).players;
    return SubContractPage(
      contract: widget.routeArgument.contractInfo,
      subtitle:
          "Qui a remporté le ${widget.routeArgument.contractInfo.displayName} ?",
      isModification: widget.routeArgument.isForModification,
      isValid: _selectedPlayer != null,
      itemsByPlayer: {
        for (var player in players)
          player.name: player == _selectedPlayer ? 1 : 0
      },
      child: _buildFields(),
    );
  }
}
