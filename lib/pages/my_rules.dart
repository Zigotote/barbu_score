import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/utils/storage.dart';
import 'package:flutter/material.dart';

import '../commons/widgets/default_page.dart';

class MyRules extends StatelessWidget {
  const MyRules({super.key});

  _buildTitle(TextTheme textTheme, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: textTheme.headlineSmall),
    );
  }

  _buildSubtitle(TextTheme textTheme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: textTheme.titleLarge),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DefaultPage(
      title: "Règles du jeu",
      hasLeading: true,
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Le barbu est un jeu pour 3 à 6 joueurs se jouant avec un jeu de 52 cartes. L'objectif est de remporter le moins de points possible.",
            ),
            _buildTitle(textTheme, "Préparation du jeu"),
            const Text(
                "Le jeu se joue avec n*8 cartes, où n correspond au nombre de joueurs. Les as sont les cartes les plus fortes. Avant de jouer il faut retirer les cartes les plus petites jusqu'à obtenir le nombre requis. Pour une partie à 4 joueurs tous les cartes de valeurs 2, 3, 4, 5 et 6 sont ainsi retirées du paquet."),
            _buildTitle(textTheme, "Principe du jeu"),
            const Text(
                "Le jeu est composé de 7 contrats devant être réalisés par tous les joueurs. Un contrat correspond à une manche de jeu. Au début de son tour, le premier joueur sélectionne un contrat à réaliser. Il l'annonce et débute la manche. A la fin de la manche, les points sont comptés, les cartes mélangées et distribuées et le joueur à gauche du premier joueur choisit un contrat à réaliser. La partie se termine lorsque tous les joueurs ont réalisé l'ensemble des contrats."),
            _buildTitle(textTheme, "Les contrats"),
            ...ContractsInfo.values.map((contract) {
              final settings = MyStorage.getSettings(contract);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSubtitle(textTheme, contract.displayName),
                  Text(settings.filledRules(contract.rules)),
                  if (!settings.isActive)
                    const Text(
                      "Ce contrat est désactivé pour vos parties.",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                ],
              );
            }),
            _buildTitle(textTheme, "Déroulement d'une manche"),
            const Text(
                "Le joueur qui choisit le contrat l'annonce et commence à jouer. Il pose la carte de son choix. Les joueurs jouent ensuite dans le sens des aiguilles d'une montre. Si un joueur ne possède pas de carte de la couleur demandée, il peut poser n'importe quelle carte de son paquet. La valeur de cette carte sera alors considérée comme nulle. A la fin du tour, le joueur ayant posé la carte de la plus grande valeur emporte le pli. C'est lui qui démarrera le pli suivant. La manche s'arrête lorsque les joueurs ont joué toutes leurs cartes. Les points sont ensuite comptés selon le contrat choisi par le premier joueur, et une nouvelle manche est démarrée par le joueur à sa gauche."),
          ],
        ),
      ),
    );
  }
}
