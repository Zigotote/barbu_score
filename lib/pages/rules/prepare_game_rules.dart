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
      title: "Préparation du jeu",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text("Pour une partie à"),
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
                  label: "Déplier le choix",
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
                selectedTrailingIcon: Semantics(
                  label: "Replier le choix",
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
              const Text("joueurs."),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Le jeu se joue avec ${nbPlayersExample * 8} cartes ($nbPlayersExample \u00d7 8).",
          ),
          const SizedBox(height: 8),
          const Text(
            "Les as sont les cartes les plus fortes. Avant de jouer il faut retirer les cartes les plus faibles jusqu'à obtenir le nombre requis.",
          ),
          const SizedBox(height: 16),
          Text(
            "A $nbPlayersExample joueurs, il faut donc retirer toutes les cartes : ${getCardsToTakeOut(nbPlayersExample).join(", ")}.",
          ),
        ],
      ),
    );
  }
}
