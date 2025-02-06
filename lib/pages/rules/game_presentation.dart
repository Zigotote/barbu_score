import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:flutter/material.dart';

import 'widgets/rules_page.dart';

class GamePresentation extends StatelessWidget {
  /// The index of the page in the order of rules pages
  final int pageIndex;

  const GamePresentation(this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return RulesPage(
      pageIndex: pageIndex,
      title: "Règles du jeu",
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            "Le barbu est un jeu pour $kNbPlayersMin à $kNbPlayersMax joueurs se jouant avec un jeu de 52 cartes. L'objectif est de remporter le moins de points possible.",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text(
              "Principe du jeu",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Text(
            "Ce jeu de plis est composé de ${ContractsInfo.values.length} contrats devant être réalisés par tous les joueurs. Chaque contrat possède des règles particulières, qui seront appliquées durant la manche de jeu.",
          ),
          const Text(
            "La partie se termine lorsque tous les joueurs ont réalisé l'ensemble des contrats.",
          ),
        ],
      ),
    );
  }
}
