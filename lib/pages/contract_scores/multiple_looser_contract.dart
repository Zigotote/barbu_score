import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/pages/contract_scores/utils/save_contract.dart';
import 'package:barbu_score/pages/contract_scores/widgets/rules_button.dart';
import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/models/contract_info.dart';
import '../../commons/models/contract_models.dart';
import '../../commons/models/player.dart';
import '../../commons/providers/contracts_manager.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/utils/snackbar.dart';
import '../../commons/widgets/colored_container.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../commons/widgets/my_subtitle.dart';

/// A page to fill the scores for a contract where each player has a different score
class MultipleLooserContractPage extends ConsumerStatefulWidget
    with SaveContract {
  /// The contract the player choose
  final ContractsInfo contract;

  /// The saved values for this contract, if it has already been filled
  final ContractWithPointsModel? contractModel;

  const MultipleLooserContractPage(
    this.contract, {
    super.key,
    this.contractModel,
  });

  @override
  ConsumerState<MultipleLooserContractPage> createState() =>
      _MultipleLooserContractPageState();
}

class _MultipleLooserContractPageState
    extends ConsumerState<MultipleLooserContractPage> {
  /// The map which links each player name to the number of items he has
  late Map<String, int> _itemsByPlayer;

  /// The number of cards with points removed from the deck for this round (only displayed if random cards are withdrawn in game settings)
  late int nbWithdrawnCards;

  /// The players of the game
  late List<Player> _players;

  /// The model of the contract
  late final ContractWithPointsModel contractModel;

  @override
  void initState() {
    super.initState();
    _players = ref.read(playGameProvider).players;
    if (widget.contractModel != null) {
      contractModel = widget.contractModel!;
      _itemsByPlayer = contractModel.itemsByPlayer;
      nbWithdrawnCards =
          contractModel.nbItems -
          _itemsByPlayer.values.fold(
            0,
            (previousValue, element) => previousValue + element,
          );
    } else {
      contractModel =
          ref
                  .read(contractsManagerProvider)
                  .getContractManager(widget.contract)
                  .model
              as ContractWithPointsModel;
      _itemsByPlayer = {for (var player in _players) player.name: 0};
      nbWithdrawnCards = 0;
    }
  }

  ///Returns true if the score is valid, false otherwise
  bool get _isValid => contractModel.isValid(_itemsByPlayer, nbWithdrawnCards);

  String get _itemName => context.l10n.itemsName(widget.contract);

  /// Adds one item to the [player] if given, to [nbWithdrawnCards] if not. Only if item still can be added
  void _addItem([Player? player]) {
    if (_isValid) {
      SnackBarUtils.instance.openSnackBar(
        context: context,
        title: context.l10n.errorAddItems,
        text: context.l10n.errorAddItemsDetails(
          _itemName,
          contractModel.nbItems,
        ),
      );
    } else if (player != null) {
      int nbItems = _itemsByPlayer[player.name]!;
      setState(() {
        _itemsByPlayer[player.name] = nbItems + 1;
      });
    } else {
      setState(() => nbWithdrawnCards++);
    }
  }

  /// Removes one item from the [player]. It can't go behind 0
  void _removeItem(Player player) {
    int nbItems = _itemsByPlayer[player.name]!;
    if (nbItems >= 1) {
      setState(() {
        _itemsByPlayer[player.name] = nbItems - 1;
      });
    }
  }

  Widget _buildFields() {
    final int nbColumns =
        (MediaQuery.sizeOf(context).width /
                MediaQuery.textScalerOf(context).scale(500))
            .ceil();
    return LayoutGrid(
      columnSizes: List.filled(nbColumns, 1.fr),
      rowSizes: List.filled((_players.length / nbColumns).ceil(), auto),
      rowGap: 16,
      columnGap: 16,
      children: _players
          .map(
            (player) => ColoredContainer(
              color: player.color,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(player.name)),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: Theme.of(
                        context,
                      ).colorScheme.convertMyColor(player.color),
                    ),
                    onPressed: () => _removeItem(player),
                    tooltip: context.l10n.withdrawItem(_itemName),
                  ),
                  Container(
                    width: MediaQuery.textScalerOf(context).scale(20),
                    alignment: Alignment.center,
                    child: Text(_itemsByPlayer[player.name].toString()),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(
                        context,
                      ).colorScheme.convertMyColor(player.color),
                    ),
                    onPressed: () => _addItem(player),
                    tooltip: context.l10n.addItem(_itemName),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  /// Builds the field to fill the number of important withdrawn cards for this round
  Widget _buildWithdrawCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            if (nbWithdrawnCards >= 1) {
              setState(() => nbWithdrawnCards--);
            }
          },
          icon: Icon(Icons.remove),
          tooltip: context.l10n.addItem(
            _itemName,
          ), // TODO Océane gérer la traduction
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.delete_outlined,
              size: MediaQuery.textScalerOf(context).scale(60),
            ),
            Positioned(
              bottom: MediaQuery.textScalerOf(context).scale(15),
              child: Text("$nbWithdrawnCards"),
            ),
          ],
        ),
        IconButton(
          onPressed: () => _addItem(),
          icon: Icon(Icons.add),
          tooltip: context.l10n.withdrawItem(
            _itemName,
          ), // TODO Océane gérer la traduction
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            context.l10n.nbItemsByPlayer(_itemName),
            backgroundColor: widget.contract.color,
          ),
          _buildFields(),
        ],
      ),
      bottomWidget: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          if ([
                ContractsInfo.noQueens,
                ContractsInfo.noHearts,
              ].contains(widget.contract) &&
              ref.read(storageProvider).getGameSettings().withdrawRandomCards)
            _buildWithdrawCards(),
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
