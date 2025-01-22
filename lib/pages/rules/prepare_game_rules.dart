import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../commons/utils/constants.dart';
import '../../commons/utils/game_helpers.dart';
import 'widgets/rules_page.dart';
import 'widgets/section_title.dart';

class PrepareGameRules extends ConsumerStatefulWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const PrepareGameRules(this.pageIndex, {super.key});

  @override
  ConsumerState<PrepareGameRules> createState() => _PrepareGameRulesState();
}

class _PrepareGameRulesState extends ConsumerState<PrepareGameRules> {
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
          const Text(
            "Le jeu se joue avec n \u00d7 8 cartes, où n correspond au nombre de joueurs.",
          ),
          const Text(
            "Les as sont les cartes les plus fortes. Avant de jouer il faut retirer les cartes les plus faibles jusqu'à obtenir le nombre requis.",
          ),
          const SectionTitle("Exemple"),
          Row(
            children: [
              const Text("Pour une partie à "),
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
                trailingIcon: const Icon(Icons.keyboard_arrow_down),
                selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
              ),
              const Text(" joueurs."),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Retirer toutes les cartes : ${getCardsToTakeOut(nbPlayersExample).join(", ")}.",
          ),
        ],
      ),
    );
  }
}
