import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:barbu_score/commons/widgets/my_dropdown.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/utils/constants.dart';
import 'widgets/rules_page.dart';

class PrepareGameRules extends ConsumerStatefulWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const PrepareGameRules(this.pageIndex, {super.key});

  @override
  ConsumerState<PrepareGameRules> createState() => _PrepareGameRulesState();
}

class _PrepareGameRulesState extends ConsumerState<PrepareGameRules> {
  int nbPlayersExample = 4;

  Widget _buildCardsToKeepText(GameSettings gameSettings) {
    if (gameSettings.withdrawRandomCards) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.nbDecksRules(
              gameSettings.getNbDecks(nbPlayersExample),
              gameSettings.nbCardsInDeck,
            ),
          ),
          const SizedBox(height: 8),
          Text(context.l10n.cardsOrder),
          const SizedBox(height: 16),
          Text(
            context.l10n.withdrawnCardsRules(
              gameSettings.getNbTricksByRound(nbPlayersExample),
            ),
          ),
        ],
      );
    }

    String cardsToKeepText;
    final cardsToKeep = gameSettings.getCardsToKeep(nbPlayersExample);
    final cardToKeepPartially = cardsToKeep.entries.firstWhereOrNull(
      (cardEntry) =>
          cardEntry.value !=
          gameSettings.getNbCardsOfEachValue(nbPlayersExample),
    );
    if (cardToKeepPartially != null) {
      cardsToKeepText =
          "${context.l10n.cardsToKeepForPlayers(nbPlayersExample, gameSettings.getNbDecks(nbPlayersExample), gameSettings.nbCardsInDeck, cardsToKeep.entries.where((cardEntry) => cardEntry.key != cardToKeepPartially.key).map((cardEntry) => context.l10n.cardName(cardEntry.key)).join(", "))} ${context.l10n.cardsToKeepPartially(cardToKeepPartially.value, context.l10n.cardName(cardToKeepPartially.key))}.";
    } else {
      cardsToKeepText = context.l10n.cardsToKeepForPlayers(
        nbPlayersExample,
        gameSettings.getNbDecks(nbPlayersExample),
        gameSettings.nbCardsInDeck,
        "${cardsToKeep.entries.map((cardEntry) => context.l10n.cardName(cardEntry.key)).join(", ")}.",
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.nbCardsRules(
            gameSettings.getNbCards(nbPlayersExample),
            gameSettings.getNbTricksByRound(nbPlayersExample),
          ),
        ),
        const SizedBox(height: 8),
        Text(context.l10n.cardsOrder),
        const SizedBox(height: 16),
        Text(cardsToKeepText),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameSettings = ref.watch(storageProvider).getGameSettings();
    return RulesPage(
      pageIndex: widget.pageIndex,
      title: context.l10n.prepareGameRules,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(context.l10n.forGameAt),
              MyDropdownMenu(
                context: context,
                dropdownMenuEntries: [
                  for (
                    var nbPlayers = kNbPlayersMin;
                    nbPlayers <= kNbPlayersMax;
                    nbPlayers++
                  )
                    DropdownMenuEntry(value: nbPlayers, label: "$nbPlayers"),
                ],
                initialSelection: nbPlayersExample,
                onSelected: (nbPlayers) =>
                    setState(() => nbPlayersExample = nbPlayers ?? 4),
              ),
              Text("${context.l10n.players}."),
            ],
          ),
          const SizedBox(height: 16),
          _buildCardsToKeepText(gameSettings),
        ],
      ),
    );
  }
}
