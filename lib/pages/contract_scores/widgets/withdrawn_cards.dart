import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';

class WithdrawnCards extends StatelessWidget {
  /// The name of the card that can be withdrawn
  final String cardName;

  /// The actual number of withdrawn cards
  final int nbWithdrawnCards;

  /// The function to call to remove a card from withdrawn cards
  final void Function() removeCard;

  /// The function to call to add a card to withdrawn cards
  final void Function() addCard;

  const WithdrawnCards({
    super.key,
    required this.cardName,
    int? nbWithdrawnCards,
    required this.removeCard,
    required this.addCard,
  }) : nbWithdrawnCards = nbWithdrawnCards ?? 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            if (nbWithdrawnCards >= 1) {
              removeCard();
            }
          },
          icon: Icon(Icons.remove),
          tooltip: context.l10n.withdrawCard,
        ),
        Tooltip(
          message: context.l10n.withdrawnCardsName(cardName),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.delete_outline_outlined,
                size: MediaQuery.textScalerOf(context).scale(60),
                semanticLabel: context.l10n.withdrawnCards,
              ),
              Positioned(
                bottom: MediaQuery.textScalerOf(context).scale(15),
                child: Text("$nbWithdrawnCards"),
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
