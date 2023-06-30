import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../commons/widgets/default_page.dart';

class MyRules extends GetView {
  _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: Get.textTheme.headlineSmall),
    );
  }

  _buildSubtitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: Get.textTheme.titleLarge),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            _buildTitle("Préparation du jeu"),
            const Text(
                "Le jeu se joue avec n*8 cartes, où n correspond au nombre de joueurs. Les as sont les cartes les plus fortes. Avant de jouer il faut retirer les cartes les plus petites jusqu'à obtenir le nombre requis. Pour une partie à 4 joueurs tous les cartes de valeurs 2, 3, 4, 5 et 6 sont ainsi retirées du paquet."),
            _buildTitle("Principe du jeu"),
            const Text(
                "Le jeu est composé de 7 contrats devant être réalisés par tous les joueurs. Un contrat correspond à une manche de jeu. Au début de son tour, le premier joueur sélectionne un contrat à réaliser. Il l'annonce et débute la manche. A la fin de la manche, les points sont comptés, les cartes mélangées et distribuées et le joueur à gauche du premier joueur choisit un contrat à réaliser. La partie se termine lorsque tous les joueurs ont réalisé l'ensemble des contrats."),
            _buildTitle("Les contrats"),
            _buildSubtitle("Barbu"),
            const Text(
                "Le joueur emportant le roi de coeur (Barbu) marque 50 points."),
            _buildSubtitle("Sans coeurs"),
            const Text(
                'Chaque joueur marque 5 points par coeur remporté. Si un joueur a tous les coeurs, son score devient négatif.'),
            _buildSubtitle("Sans dames"),
            const Text(
                'Chaque joueur marque 10 points par dame remportée. Si un joueur a toutes les dames, il perd 40 points.'),
            _buildSubtitle("Sans plis"),
            const Text(
                'Chaque joueur marque 5 points par pli remporté. Si un joueur remporte tous les plis, il perd 40 points.'),
            _buildSubtitle("Dernier"),
            const Text("Le joueur emportant le dernier pli marque 40 points."),
            _buildSubtitle("Salade"),
            const Text(
                "Ce contrat est une combinaison de tous les contrats précédents. Il ne faut donc pas remporter les coeurs, le Barbu, les dames, les plis et le dernier pli. C'est le contrat qui peut faire marquer le plus de points puisque les points de chaque contrat s'additionnent."),
            _buildSubtitle("Réussite"),
            const Text(
                "Le joueur choisissant ce contrat détermine la valeur d'ouverture de la réussite. S'il possède une carte de cette valeur, il la pose sur la table, sinon il passe son tour. Le joueur suivant peut ensuite poser une carte de même couleur et de valeur directement supérieure ou inférieure à cette première carte. Il peut aussi poser une carte de la valeur d'ouverture. S'il ne peut pas poser de carte il indique qu'il passe. Le jeu se poursuite ainsi jusqu'à ce que tous les joueurs aient fini leur paquet. Les joueurs marquent un nombre de points dépendant de leur ordre de fin."),
            _buildTitle("Déroulement d'une manche"),
            const Text(
                "Le joueur qui choisit le contrat l'annonce et commence à jouer. Il pose la carte de son choix. Les joueurs jouent ensuite dans le sens des aiguilles d'une montre. Si un joueur ne possède pas de carte de la couleur demandée, il peut poser n'importe quelle carte de son paquet. La valeur de cette carte sera alors considérée comme nulle. A la fin du tour, le joueur ayant posé la carte de la plus grande valeur emporte le pli. C'est lui qui démarrera le pli suivant. La manche s'arrête lorsque les joueurs ont joué toutes leurs cartes. Les points sont ensuite comptés selon le contrat choisi par le premier joueur, et une nouvelle manche est démarrée par le joueur à sa gauche."),
          ],
        ),
      ),
    );
  }
}
