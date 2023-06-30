import 'package:barbu_score/models/player.dart';
import 'package:barbu_score/pages/play_game/contracts/widgets/contract_page.dart';
import 'package:barbu_score/pages/play_game/models/contract_route_argument.dart';
import 'package:barbu_score/pages/play_game/notifiers/play_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/snackbar.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/list_layouts.dart';
import '../models/contract_models.dart';

/// A page to fill the scores for a contract where each player has a different score
class IndividualScoresContract extends ConsumerStatefulWidget {
  /// The contract the player choose and the previous values, if it needs to be modified
  final ContractRouteArgument routeArgument;

  /// The maximal number of item that can be gained during the contract
  final int itemsMax;

  IndividualScoresContract(this.routeArgument)
      : itemsMax = (routeArgument.contractInfo.contract
                as AbstractMultipleLooserContractModel)
            .expectedItems;

  @override
  ConsumerState<IndividualScoresContract> createState() =>
      _IndividualScoresContractState();
}

class _IndividualScoresContractState
    extends ConsumerState<IndividualScoresContract> {
  /// The map which links each player name to the number of items he has
  late Map<String, int> _playerItems;

  /// The players of the game
  late List<Player> _players;

  @override
  void initState() {
    super.initState();
    _players = ref.read(playGameProvider).players;
    if (widget.routeArgument.isForModification) {
      _playerItems = widget.routeArgument.contractValues!.playerItems;
    } else {
      _playerItems = Map.fromIterable(
        _players,
        key: (player) => player.name,
        value: (_) => 0,
      );
    }
  }

  ///Returns true if the score is valid, false otherwise
  bool get _isValid {
    final int currentScore = _playerItems.values
        .fold(0, (previousValue, element) => previousValue + element);
    return currentScore == widget.itemsMax;
  }

  /// Increases the score of the player, only if the total score is less than the contract max score
  void _increaseScore(Player player) {
    if (this._isValid) {
      SnackbarUtils.instance.openSnackBar(
        context: context,
        title: "Ajout de points impossible",
        text:
            "Le nombre d'items dépasse le nombre d'éléments pouvant être remporté, fixé à ${widget.itemsMax}.",
      );
    } else {
      int playerScore = _playerItems[player.name]!;
      setState(() {
        _playerItems[player.name] = playerScore + 1;
      });
    }
  }

  /// Decreases the score of the player. It can't go behind 0
  void _decreaseScore(Player player) {
    int playerScore = _playerItems[player.name]!;
    if (playerScore >= 1) {
      setState(() {
        _playerItems[player.name] = playerScore - 1;
      });
    }
  }

  Widget _buildFields() {
    return MyList(
      itemCount: _playerItems.length,
      itemBuilder: (_, index) {
        Player player = _players[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButtonCustomColor(
                icon: Icons.remove,
                color: player.color,
                onPressed: () => _decreaseScore(player),
              ),
              Column(
                children: [
                  Text(player.name),
                  Text(_playerItems[player.name].toString())
                ],
              ),
              ElevatedButtonCustomColor(
                icon: Icons.add,
                color: player.color,
                onPressed: () => _increaseScore(player),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContractPage(
      subtitle:
          "Nombre de ${widget.routeArgument.contractInfo.displayName.replaceFirst("Sans ", "")} par joueur",
      contract: widget.routeArgument.contractInfo,
      isModification: widget.routeArgument.isForModification,
      isValid: _isValid,
      itemsByPlayer: _playerItems,
      child: _buildFields(),
    );
  }
}
