import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/contracts_manager.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/list_layouts.dart';
import 'widgets/sub_contract_page.dart';

/// A page to fill the scores for a contract where only one player can loose
class OneLooserContractPage extends ConsumerStatefulWidget {
  /// The contract the player choose
  final ContractsInfo contract;

  /// The saved values for this contract, if it has already been filled
  final OneLooserContractModel? contractModel;

  const OneLooserContractPage(this.contract, {super.key, this.contractModel});

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
    if (widget.contractModel != null) {
      contractModel = widget.contractModel!;
      final String playerNameWithItem = contractModel.itemsByPlayer.entries
          .firstWhere((player) => player.value == 1)
          .key;
      _selectedPlayer =
          _players.firstWhere((player) => player.name == playerNameWithItem);
    } else {
      contractModel = ref
          .read(contractsManagerProvider)
          .getContractManager(widget.contract)
          .model as OneLooserContractModel;
    }
  }

  /// Selects the given player
  void _selectPlayer(Player player) {
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
      contract: widget.contract,
      subtitle: context.l10n.whoWonItem(
        context.l10n.contractName(widget.contract),
      ),
      isValid: _selectedPlayer != null,
      itemsByPlayer: {
        for (var player in players)
          player.name: player == _selectedPlayer ? 1 : 0
      },
      child: _buildFields(),
    );
  }
}
