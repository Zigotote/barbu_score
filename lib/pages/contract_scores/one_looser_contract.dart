import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/contract_scores/utils/save_contract.dart';
import 'package:barbu_score/pages/contract_scores/widgets/discarded_cards.dart';
import 'package:barbu_score/pages/contract_scores/widgets/rules_button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/contracts_manager.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/providers/storage.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/my_list_layouts.dart';
import '../../commons/widgets/my_subtitle.dart';

/// A page to fill the scores for a contract where only one player can loose
class OneLooserContractPage extends ConsumerStatefulWidget with SaveContract {
  /// The contract the player choose
  final ContractsInfo contract;

  /// The saved values for this contract, if it has already been filled
  final ContractWithPointsModel? contractModel;

  const OneLooserContractPage(this.contract, {super.key, this.contractModel});

  @override
  ConsumerState<OneLooserContractPage> createState() =>
      _OneLooserContractPageState();
}

class _OneLooserContractPageState extends ConsumerState<OneLooserContractPage> {
  /// The selected player
  Player? _selectedPlayer;

  /// The indicator to know if the card has been removed from the deck (only displayed if random cards are discarded in game settings)
  late bool hasDiscardedCard;

  /// The players of the game
  late final List<Player> _players;

  /// The settings for the game
  late final GameSettings _gameSettings;

  /// The model of the contract
  late final ContractWithPointsModel contractModel;

  @override
  initState() {
    super.initState();
    _players = ref.read(playGameProvider).players;
    _gameSettings = ref.read(storageProvider).getGameSettings();
    if (widget.contractModel != null) {
      contractModel = widget.contractModel!;
      final String? playerNameWithItem = contractModel.itemsByPlayer.entries
          .firstWhereOrNull((player) => player.value == 1)
          ?.key;
      _selectedPlayer = _players.firstWhereOrNull(
        (player) => player.name == playerNameWithItem,
      );
      hasDiscardedCard = _selectedPlayer == null;
    } else {
      contractModel =
          ref
                  .read(contractsManagerProvider)
                  .getContractManager(widget.contract)
                  .model
              as ContractWithPointsModel;
      hasDiscardedCard = false;
    }
  }

  Map<String, int> get _itemsByPlayer => {
    for (var player in _players) player.name: player == _selectedPlayer ? 1 : 0,
  };

  bool get _isValid =>
      contractModel.isValid(_itemsByPlayer, hasDiscardedCard ? 1 : 0);

  /// Selects the given player
  void _selectPlayer(Player player) {
    setState(() {
      _selectedPlayer = player;
      hasDiscardedCard = false;
    });
  }

  /// Build each player's button and the box to show which one is currently selected
  Widget _buildFields() {
    return MyGrid(
      children: _players.map((player) {
        final isPlayerSelected = _selectedPlayer == player;
        return ElevatedButtonCustomColor.player(
          text: player.name,
          color: isPlayerSelected ? null : player.color,
          onPressed: () => _selectPlayer(player),
          backgroundColor: isPlayerSelected ? player.color : null,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxNbDiscardedCards = _gameSettings.getNbDiscardedCardsByRound(
      _players.length,
    );
    return MyDefaultPage(
      appBar: MyPlayerAppBar(
        player: ref.watch(playGameProvider).currentPlayer,
        context: context,
        trailing: RulesButton(widget.contract),
      ),
      content: Column(
        spacing: 24,
        children: [
          MySubtitle(
            context.l10n.whoWonItem(context.l10n.contractName(widget.contract)),
            backgroundColor: widget.contract.color,
          ),
          _buildFields(),
        ],
      ),
      bottomWidget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 16,
        children: [
          if (widget.contract == ContractsInfo.barbu && maxNbDiscardedCards > 0)
            DiscardedCards(
              cardName: context.l10n.itemsName(widget.contract),
              nbDiscardedCards: hasDiscardedCard ? 1 : 0,
              removeCard: () => setState(() => hasDiscardedCard = false),
              addCard: () => setState(() {
                hasDiscardedCard = true;
                _selectedPlayer = null;
              }),
            ),
          ElevatedButtonFullWidth(
            onPressed: _isValid
                ? () => widget.saveContract(
                    context,
                    ref,
                    (ref
                                .read(contractsManagerProvider)
                                .getContractManager(widget.contract)
                                .model
                            as ContractWithPointsModel)
                        .copyWith(itemsByPlayer: _itemsByPlayer),
                  )
                : null,
            child: Text(
              context.l10n.validateScores,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
