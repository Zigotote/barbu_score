import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';

class DiscardedCards extends StatelessWidget {
  /// The name of the card that can be discarded
  final String cardName;

  /// The actual number of discarded cards
  final int nbDiscardedCards;

  /// The function to call to remove a card from discarded cards
  final void Function() removeCard;

  /// The function to call to add a card to discarded cards
  final void Function() addCard;

  const DiscardedCards({
    super.key,
    required this.cardName,
    int? nbDiscardedCards,
    required this.removeCard,
    required this.addCard,
  }) : nbDiscardedCards = nbDiscardedCards ?? 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            if (nbDiscardedCards >= 1) {
              removeCard();
            }
          },
          icon: Icon(Icons.remove),
          tooltip: context.l10n.discardCard,
        ),
        Tooltip(
          message: context.l10n.discardedCardsName(cardName),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.delete_outline_outlined,
                size: MediaQuery.textScalerOf(context).scale(60),
                semanticLabel: context.l10n.discardedCards,
              ),
              Positioned(
                bottom: MediaQuery.textScalerOf(context).scale(15),
                child: Text("$nbDiscardedCards"),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: addCard,
          icon: Icon(Icons.add),
          tooltip: context.l10n.addCard,
        ),
      ],
    );
  }
}
