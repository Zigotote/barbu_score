import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/contracts_manager.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/utils/snackbar.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/list_layouts.dart';
import 'models/contract_route_argument.dart';
import 'widgets/contract_page.dart';

/// A page to fill the scores for a contract where each player has a different score
class MultipleLooserContractPage extends ConsumerStatefulWidget {
  /// The contract the player choose and the previous values, if it needs to be modified
  final ContractRouteArgument routeArgument;

  /// The name of the items won for this contract
  final String itemsName;

  MultipleLooserContractPage(this.routeArgument, {super.key})
      : itemsName =
            routeArgument.contractInfo.displayName.replaceFirst("Sans ", "");

  @override
  ConsumerState<MultipleLooserContractPage> createState() =>
      _MultipleLooserContractPageState();
}

class _MultipleLooserContractPageState
    extends ConsumerState<MultipleLooserContractPage> {
  /// The map which links each player name to the number of items he has
  late Map<String, int> _itemsByPlayer;

  /// The players of the game
  late List<Player> _players;

  /// The model of the contract
  late final MultipleLooserContractModel contractModel;

  @override
  void initState() {
    super.initState();
    _players = ref.read(playGameProvider).players;
    if (widget.routeArgument.isForModification) {
      contractModel =
          widget.routeArgument.contractModel as MultipleLooserContractModel;
      _itemsByPlayer = contractModel.itemsByPlayer;
    } else {
      contractModel = ref
          .read(contractsManagerProvider)
          .getContractManager(widget.routeArgument.contractInfo)
          .model as MultipleLooserContractModel;
      _itemsByPlayer = {for (var player in _players) player.name: 0};
    }
  }

  ///Returns true if the score is valid, false otherwise
  bool get _isValid => contractModel.isValid(_itemsByPlayer);

  /// Increases the score of the player, only if the total score is less than the contract max score
  void _increaseScore(Player player) {
    if (_isValid) {
      SnackBarUtils.instance.openSnackBar(
        context: context,
        title: "Ajout de points impossible",
        text:
            "Le nombre de ${widget.itemsName} dépasse le nombre d'éléments pouvant être remporté, fixé à ${contractModel.nbItems}.",
      );
    } else {
      int playerScore = _itemsByPlayer[player.name]!;
      setState(() {
        _itemsByPlayer[player.name] = playerScore + 1;
      });
    }
  }

  /// Decreases the score of the player. It can't go behind 0
  void _decreaseScore(Player player) {
    int playerScore = _itemsByPlayer[player.name]!;
    if (playerScore >= 1) {
      setState(() {
        _itemsByPlayer[player.name] = playerScore - 1;
      });
    }
  }

  Widget _buildFields() {
    return MyList(
      itemCount: _itemsByPlayer.length,
      itemBuilder: (_, index) {
        Player player = _players[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              ElevatedButtonCustomColor.player(
                icon: Icons.remove,
                color: player.color,
                onPressed: () => _decreaseScore(player),
                semantics: "Retirer ${widget.itemsName}",
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      player.name,
                      textAlign: TextAlign.center,
                    ),
                    Text(_itemsByPlayer[player.name].toString())
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButtonCustomColor.player(
                icon: Icons.add,
                color: player.color,
                onPressed: () => _increaseScore(player),
                semantics: "Ajouter ${widget.itemsName}",
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubContractPage(
      contract: widget.routeArgument.contractInfo,
      subtitle: "Nombre de ${widget.itemsName} par joueur",
      isModification: widget.routeArgument.isForModification,
      isValid: _isValid,
      itemsByPlayer: _itemsByPlayer,
      child: _buildFields(),
    );
  }
}
