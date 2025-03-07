import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';

import '../../commons/utils/constants.dart';
import '../../commons/utils/game_helpers.dart';
import 'widgets/rules_page.dart';

class PrepareGameRules extends StatefulWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const PrepareGameRules(this.pageIndex, {super.key});

  @override
  State<PrepareGameRules> createState() => _PrepareGameRulesState();
}

class _PrepareGameRulesState extends State<PrepareGameRules> {
  int nbPlayersExample = 4;

  @override
  Widget build(BuildContext context) {
    return RulesPage(
      pageIndex: widget.pageIndex,
      title: context.l10n.prepareGameRules,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(context.l10n.forGameAt),
              DropdownMenu(
                width: 80,
                dropdownMenuEntries: [
                  for (var nbPlayers = kNbPlayersMin;
                      nbPlayers <= kNbPlayersMax;
                      nbPlayers++)
                    DropdownMenuEntry(value: nbPlayers, label: "$nbPlayers")
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
            context.l10n.nbCardsRules(nbPlayersExample * 8, nbPlayersExample),
          ),
          const SizedBox(height: 8),
          Text(context.l10n.cardsOrder),
          const SizedBox(height: 16),
          Text(
            context.l10n.withdrawCardsForPlayers(
              nbPlayersExample,
              getCardsToTakeOut(nbPlayersExample).join(", "),
            ),
          ),
        ],
      ),
    );
  }
}
