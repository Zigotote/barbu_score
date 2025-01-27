import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/rules_page.dart';

class GamePresentation extends ConsumerWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const GamePresentation(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RulesPage(
      pageIndex: pageIndex,
      title: "Règles du jeu",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            "Le barbu est un jeu pour 3 à 6 joueurs se jouant avec un jeu de 52 cartes. L'objectif est de remporter le moins de points possible.",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text(
              "Principe du jeu",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Text(
            "Ce jeu de plis est composé de 7 contrats devant être réalisés par tous les joueurs. Chaque contrat possède des règles particulières, qui seront appliquées durant la manche de jeu.",
          ),
          const Text(
            "La partie se termine lorsque tous les joueurs ont réalisé l'ensemble des contrats.",
          ),
        ],
      ),
    );
  }
}
