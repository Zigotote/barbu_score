import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
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
  late final GameSettings gameSettings;

  @override
  void initState() {
    gameSettings = ref.read(storageProvider).getGameSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              DropdownMenu(
                width: MediaQuery.of(context).textScaler.scale(90),
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
                trailingIcon: Semantics(
                  label: context.l10n.unfold,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
                selectedTrailingIcon: Semantics(
                  label: context.l10n.fold,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
              Text("${context.l10n.players}."),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.nbCardsRules(
              gameSettings.getNbCards(nbPlayersExample),
              nbPlayersExample,
              gameSettings.getNbTricksByRound(nbPlayersExample),
            ),
          ),
          const SizedBox(height: 8),
          Text(context.l10n.cardsOrder),
          const SizedBox(height: 16),
          Text(
            context.l10n.cardsToKeepForPlayers(
              nbPlayersExample,
              gameSettings.getNbDecks(nbPlayersExample),
              gameSettings
                  .getCardsToKeep(nbPlayersExample)
                  .map((cardIndex) => context.l10n.cardName(cardIndex))
                  .join(", "),
            ),
          ),
        ],
      ),
    );
  }
}
