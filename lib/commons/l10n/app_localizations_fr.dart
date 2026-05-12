// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'A propos';

  @override
  String get aboutLea => 'Léa LOUESDON, créatrice des éléments graphiques';

  @override
  String get aboutOceane =>
      'Océane GILLARD, chargée du développement de l\'application';

  @override
  String get aboutTheApp =>
      'L\'application Score Barbu est développée par des passionnées qui ont à coeur de répondre au mieux aux besoins des joueurs et joueuses de Barbu !';

  @override
  String get aboutTheTeam => 'L\'équipe est composée de : ';

  @override
  String get accept => 'Oui';

  @override
  String get ace => 'as';

  @override
  String get activateContract => 'Activer le contrat';

  @override
  String get addCard => 'Ajouter une carte';

  @override
  String addItem(String item) {
    String _temp0 = intl.Intl.selectLogic(item, {'dame': 'une', 'other': 'un'});
    return 'Ajouter $_temp0 $item';
  }

  @override
  String get alertCannotActivateSalad => 'Activation impossible';

  @override
  String get alertCannotActivateSaladDetails =>
      'La salade doit posséder au moins un contrat à jouer pour être activée.';

  @override
  String get alertContractPlayed => 'Le contrat a déjà été joué';

  @override
  String alertContractPlayedBy(String players) {
    return 'Le contrat a déjà été joué par $players. Toute modification dans les paramètres de ce contrat aura des répercussions sur la partie en cours.';
  }

  @override
  String get alertExistingGame => 'Une partie sauvegardée existe';

  @override
  String get and => 'et';

  @override
  String get application => 'Application';

  @override
  String get appName => 'Le Barbu';

  @override
  String get appTheme => 'Thème de l\'application';

  @override
  String get appTitle => 'Score Barbu';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get askForFeedback =>
      'Vous avez détecté un problème ou avez une suggestion d\'amélioration ? Vous pouvez nous le signaler par mail :';

  @override
  String get availableColor => 'Couleur disponible';

  @override
  String get avatar => 'Avatar';

  @override
  String get back => 'Retour';

  @override
  String get barbu => 'Barbu';

  @override
  String get bestFriend => 'Meilleur·e ami·e';

  @override
  String get bug => 'Un bug';

  @override
  String cardInterval(String firstCard, String lastCard) {
    return '$firstCard à $lastCard';
  }

  @override
  String get cardsOrder => 'Les as sont les cartes les plus fortes.';

  @override
  String get cardsToKeep => 'Conserver les cartes';

  @override
  String cardsToKeepForPlayers(
    int nbPlayers,
    int nbDecks,
    int nbCardsInDeck,
    String cards,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      nbDecks,
      locale: localeName,
      other: 'de $nbDecks paquets',
      one: 'd\'un paquet',
    );
    return 'Avant de jouer il faut conserver les cartes les plus élevées $_temp0 de $nbCardsInDeck cartes jusqu\'à obtenir le nombre requis. A $nbPlayers, il faut donc conserver uniquement les cartes : $cards';
  }

  @override
  String cardToKeepPartially(String nbCards, String card) {
    String _temp0 = intl.Intl.selectLogic(nbCards, {
      '1': '♥',
      '2': '♥♦',
      '3': '♥♦♣',
      '4': '♥♦',
      '5': '♥♦ et un ♣',
      '6': '♥♦♣',
      '7': '♥♦♣ et un ♠',
      'other': '',
    });
    return '$card$_temp0';
  }

  @override
  String get changesSaved => 'Modifications sauvegardées';

  @override
  String get changesSavedDetails =>
      'Les changements ont été sauvegardés et sont effectifs dès maintenant.';

  @override
  String get close => 'Fermer';

  @override
  String get color => 'Couleur';

  @override
  String confirmStartGame(String players) {
    return 'Confirmer la création d\'une nouvelle partie ? Si oui, la partie précédente avec $players sera perdue.';
  }

  @override
  String get contact => 'Contact';

  @override
  String get contactByMail => 'Contacter par mail';

  @override
  String get contactReason => 'Que souhaitez-vous signaler ?';

  @override
  String get contracts => 'Contrats';

  @override
  String contractsOf(String player) {
    return 'Contrats de $player';
  }

  @override
  String get contractsRules =>
      'Le jeu du Barbu comporte les contrats suivants :';

  @override
  String contractRulesTitle(String contract) {
    return 'Règles $contract';
  }

  @override
  String get contractsToPlay => 'Contrats à jouer';

  @override
  String get createPlayers => 'Créer les joueurs et joueuses';

  @override
  String get deactivate => 'Désactiver';

  @override
  String get deactivatedForGame => 'Désactivé pour vos parties.';

  @override
  String decksOfCards(int nbDecks, int nbCards) {
    String _temp0 = intl.Intl.pluralLogic(
      nbDecks,
      locale: localeName,
      other: '$nbDecks paquets',
      one: '1 paquet',
    );
    return '$_temp0 de $nbCards cartes.';
  }

  @override
  String get deckQuestion => 'Type de paquet';

  @override
  String get defaultNbTricks => '8 plis';

  @override
  String get delete => 'Supprimer';

  @override
  String get deletePlayer => 'Supprimer la·e joueur·se';

  @override
  String get discardCard => 'Retirer une carte';

  @override
  String discardItem(String item) {
    String _temp0 = intl.Intl.selectLogic(item, {'dame': 'une', 'other': 'un'});
    return 'Retirer $_temp0 $item';
  }

  @override
  String discardNbCards(num nbCards) {
    String _temp0 = intl.Intl.pluralLogic(
      nbCards,
      locale: localeName,
      other: 'cartes',
      one: 'carte',
    );
    return 'Défausser $nbCards $_temp0.';
  }

  @override
  String discardedCardsRules(int nbTricks) {
    return 'A chaque manche, tout le monde reçoit $nbTricks cartes. Les cartes supplémentaires sont mises de côté face visible puis remélangées à la fin de la manche.';
  }

  @override
  String get discardedCards => 'Cartes retirées';

  @override
  String discardedCardsName(String item) {
    String _temp0 = intl.Intl.selectLogic(item, {
      'dame': 'retirées',
      'other': 'retirés',
    });
    return '${item}s $_temp0';
  }

  @override
  String get domino => 'Réussite';

  @override
  String dominoScoreSubtitle(String rank) {
    return 'Qui a fini $rank ?';
  }

  @override
  String get endGame => 'Fin de partie';

  @override
  String get english => 'Anglais';

  @override
  String get errorAddItem => 'Ajout d\'élément impossible';

  @override
  String errorAddItemDetails(String item, int nbItems) {
    return 'Le nombre de $item dépasse le nombre d\'éléments pouvant être remporté, fixé à $nbItems.';
  }

  @override
  String get errorDomino => 'Tout le monde n\'a pas été classé.';

  @override
  String get errorLaunchGame => 'Impossible de lancer une partie';

  @override
  String get errorLaunchGameDetails =>
      'Tous les contrats sont désactivés dans les paramètres. Il faut au moins un contrat activé pour pouvoir jouer.';

  @override
  String get errorAddDiscardedCard => 'Ajout de carte défaussée impossible';

  @override
  String errorAddDiscardedCardDetails(String item, int nbItems) {
    return 'Le nombre de $item dépasse le nombre de cartes dans la défausse, fixé à $nbItems.';
  }

  @override
  String get feature => 'Une suggestion';

  @override
  String get fold => 'Replier les choix';

  @override
  String get forGameAt => 'Pour une partie à';

  @override
  String get french => 'Français';

  @override
  String fromTheDeck(int nbDecks) {
    String _temp0 = intl.Intl.pluralLogic(
      nbDecks,
      locale: localeName,
      other: 'de $nbDecks paquets',
      one: 'du paquet',
    );
    return '$_temp0.';
  }

  @override
  String get game => 'Partie';

  @override
  String get gamePrinciple => 'Principe du jeu';

  @override
  String get gamePrincipleDetails =>
      'Ce jeu de plis est composé de différents contrats devant être réalisés par toutes les personnes. Chaque contrat possède des règles particulières, qui seront appliquées durant la manche de jeu.\nLa partie se termine lorsque tout le monde a réalisé l\'ensemble des contrats.';

  @override
  String get gameRound => 'Manche de jeu';

  @override
  String get gameRoundRules =>
      'Distribuer le même nombre de cartes à tout le monde.*Le Premier Joueur choisit le contrat qu\'il souhaite jouer et l\'annonce aux autres.*Il démarre le pli en posant une carte, qui détermine la couleur du pli.*Chaque personne pose une carte dans le sens des aiguilles d\'une montre.*Si une personne ne possède pas de carte de la couleur demandée, elle peut poser n\'importe quelle carte de son paquet. La valeur de cette carte sera alors considérée comme nulle.*A la fin du tour, la personne ayant posé la carte de la plus grande valeur emporte le pli. C\'est elle qui démarrera le pli suivant.*La manche s\'arrête lorsque les cartes ont toutes été jouées.*Les points sont ensuite comptés selon le contrat choisi par Le Premier Joueur.*La personne assise à sa gauche démarre la manche suivante.';

  @override
  String get gameSaved => 'Partie sauvegardée';

  @override
  String get go => 'C\'est parti !';

  @override
  String get goal => 'Objectif';

  @override
  String get goHome => 'Retour à l\'accueil';

  @override
  String get heart => 'coeur';

  @override
  String get hintDarkMode => 'mode sombre';

  @override
  String get hintLightMode => 'mode clair';

  @override
  String get hintForDarkMode => 'passer en mode sombre';

  @override
  String get hintForLightMode => 'passer en mode clair';

  @override
  String get invertScore => 'Inversion du score';

  @override
  String get invertScoreDetails =>
      'Si une personne remporte tout, son score est inversé.';

  @override
  String get invertScoreNegativeDetails =>
      'Si une personne remporte tout, son score devient négatif.';

  @override
  String get invertScorePositiveDetails =>
      'Si une personne remporte tout, son score devient positif.';

  @override
  String get jack => 'valet';

  @override
  String get keep => 'Conserver';

  @override
  String get king => 'roi';

  @override
  String get language => 'Langue';

  @override
  String get lastTrick => 'Dernier';

  @override
  String get loadGame => 'Charger une partie';

  @override
  String get loadGameIndication =>
      'Sélectionnez \"Charger une partie\" pour la poursuivre.';

  @override
  String loadPreviousGame(String players) {
    return 'Reprendre la partie précédente avec $players ?';
  }

  @override
  String get lowest => 'Plus faibles';

  @override
  String get maxScore => 'Score élevé';

  @override
  String get minScore => 'Score faible';

  @override
  String get mix => 'Mélanger';

  @override
  String modify(String contract) {
    return 'Modification $contract';
  }

  @override
  String get modifyContractsSettings =>
      'Les contrats sont modifiables dans la page de paramètres, pour personnaliser leurs points et variations.';

  @override
  String get modifyPlayer => 'Modifier la·e joueur·se';

  @override
  String get modifySettings => 'Modifier les paramètres';

  @override
  String get moreInfo => 'Plus d\'informations';

  @override
  String nbCards(int nbCards) {
    return '$nbCards cartes';
  }

  @override
  String nbCardsRules(int nbCards, int nbTricks) {
    return 'Le jeu se joue avec $nbCards cartes ($nbTricks cartes par personne).';
  }

  @override
  String nbDecksRules(int nbDecks, int nbCardsByDeck) {
    String _temp0 = intl.Intl.pluralLogic(
      nbDecks,
      locale: localeName,
      other: '$nbDecks paquets',
      one: '1 paquet',
    );
    return 'Le jeu se joue avec $_temp0 de $nbCardsByDeck cartes.';
  }

  @override
  String nbItemsByPlayer(String item) {
    return 'Nombre de ${item}s par personne';
  }

  @override
  String get nbTricksTooltip =>
      'Un nombre de plis optimisé revient à distribuer équitablement toutes les cartes du jeu.';

  @override
  String get nbTricksQuestion => 'Nombre de plis';

  @override
  String get next => 'Suivant';

  @override
  String get noGameFound => 'Aucune partie trouvée';

  @override
  String get noGameFoundDetails =>
      'La partie précédente n\'a pas été retrouvée. Lancement d\'une nouvelle partie.';

  @override
  String get noHearts => 'Sans coeurs';

  @override
  String get noLastTrick => 'Dernier';

  @override
  String get noQueens => 'Sans dames';

  @override
  String get noTricks => 'Sans plis';

  @override
  String get optimized => 'Optimisé';

  @override
  String get other => 'Autre';

  @override
  String get player => 'joueur·se';

  @override
  String playerNameHint(int nb) {
    return 'Nom J$nb';
  }

  @override
  String get playerTurn => 'Tour de';

  @override
  String get playersOrder => 'Ordre des joueurs et joueuses';

  @override
  String get points => 'points';

  @override
  String pointsBy(String item) {
    return 'Points par $item';
  }

  @override
  String pointsOf(String item) {
    return 'Points du $item';
  }

  @override
  String pointsForNbPlayers(int nb) {
    return 'Points à $nb joueur·ses';
  }

  @override
  String get prepareGame => 'Préparer la partie';

  @override
  String get prepareGameRules => 'Préparation du jeu';

  @override
  String get presentGame =>
      'Le barbu est un jeu de cartes pour 3 à 10 joueurs et joueuses.';

  @override
  String get presentGameGoalMaxScore =>
      'L\'objectif est de marquer le plus de points possible.';

  @override
  String get presentGameGoalMinScore =>
      'L\'objectif est de marquer le moins de points possible.';

  @override
  String get previous => 'Précédent';

  @override
  String get queen => 'dame';

  @override
  String get randoms => 'Aléatoires';

  @override
  String get ranking => 'Classement';

  @override
  String get rateApp => 'Evaluer l\'application';

  @override
  String get refuseLoadGame => 'Non, nouvelle partie';

  @override
  String get refuseStartGame => 'Non, reprendre la partie';

  @override
  String get reportBug => 'Signaler un bug';

  @override
  String get reportBugMail =>
      'Bonjour,\n\nJe souhaiterais signaler un bug rencontré sur l’application. Voici les détails :\n\n- Description du bug (expliquez ce qu\'il s’est passé, ce que vous faisiez avant que le problème apparaisse, etc.) :\n\n- Étapes pour reproduire le bug (indiquez les actions à suivre pour que le problème se reproduise) : \n\n- Comportement attendu (ce qui aurait dû se passer) :';

  @override
  String get requestFeature => 'Ajouter une amélioration';

  @override
  String get requestFeatureMail =>
      'Bonjour,\n\nJe souhaiterai proposer une nouvelle fonctionnalité pour l\'application, afin de...';

  @override
  String get rules => 'Règles du jeu';

  @override
  String rulesBarbu(int points) {
    return 'Le joueur emportant le roi de coeur (Barbu) marque $points points.';
  }

  @override
  String rulesBarbuInSalad(int points) {
    return '- le roi de coeur (Barbu) vaut $points points';
  }

  @override
  String get rulesDomino =>
      'Contrairement aux autres contrats, la réussite n\'est pas un contrat à plis. L\'objectif de ce contrat est de poser toutes les cartes du jeu sur la table, triées par couleur et dans l\'ordre croissant.\nLa personne choisissant ce contrat détermine la valeur d\'ouverture de la réussite (par exemple le valet). Si elle possède une carte de cette valeur, elle la pose sur la table, sinon elle passe son tour.\nLa personne suivante peut ensuite poser une carte de même couleur et de valeur directement supérieure ou inférieure (donc le 10 ou la dame de la couleur précédente). Elle peut aussi poser une carte de la valeur d\'ouverture. Si elle joue un as, elle peut rejouer. Si elle ne peut pas poser de carte, elle indique qu\'elle passe.\nLe jeu se poursuit ainsi jusqu\'à ce que tout le monde ait vidé sa main. L\'objectif est de poser toutes ses cartes le plus rapidement possible.';

  @override
  String rulesDominoDetailed(String player, String points) {
    return 'Contrairement aux autres contrats, la réussite n\'est pas un contrat à plis. L\'objectif de ce contrat est de poser toutes les cartes du jeu sur la table, triées par couleur et dans l\'ordre croissant.\n$player détermine la valeur d\'ouverture de la réussite (par exemple le valet), et pose une carte de cette valeur s\'il y en a dans son jeu.\nLa personne suivante pose ensuite une carte de même couleur et de valeur directement supérieure ou inférieure (donc le 10 ou la dame de la couleur précédente), ou une carte de la valeur d\'ouverture. Si elle joue un as, elle peut rejouer. Si elle ne peut pas poser de carte, elle indique qu\'elle passe.\nLe jeu se poursuit ainsi jusqu\'à ce que tout le monde ait fini vidé sa main.\n\nLes points marqués dépendent de l\'ordre de fin des joueurs et joueuses, et sont distribués comme suit :\n$points';
  }

  @override
  String rulesNoHearts(int points) {
    return 'Chaque personne marque $points points par coeur remporté.';
  }

  @override
  String rulesNoHeartsInSalad(int points) {
    return '- chaque coeur vaut $points points';
  }

  @override
  String rulesNoQueens(int points) {
    return 'Chaque personne marque $points points par dame remportée.';
  }

  @override
  String rulesNoQueensInSalad(int points) {
    return '- chaque dame vaut $points points';
  }

  @override
  String rulesNoLastTrick(int points) {
    return 'La personne emportant le dernier pli marque $points points.';
  }

  @override
  String rulesNoLastTrickInSalad(int points) {
    return '- le dernier pli vaut $points points';
  }

  @override
  String rulesNoTricks(int points) {
    return 'Chaque personne marque $points points par pli remporté.';
  }

  @override
  String rulesNoTricksInSalad(int points) {
    return '- chaque pli vaut $points points';
  }

  @override
  String rulesSalad(String contracts) {
    return 'Ce contrat est une combinaison des contrats $contracts.\nC\'est le contrat qui peut faire marquer le plus de points puisque les points de chaque contrat s\'additionnent.';
  }

  @override
  String rulesSaladDetailed(String contracts, String itemWithPoints) {
    return 'Ce contrat est une combinaison des contrats $contracts. Les points sont comptés comme suit :\n$itemWithPoints';
  }

  @override
  String rulesTrickRound(String player) {
    return '$player démarre le premier pli, et détermine ainsi sa couleur.\nLa personne ayant posé la carte de cette couleur la plus élevée remporte le pli. Elle démarre le pli suivant.';
  }

  @override
  String rulesTrumps(int points) {
    return 'Le Premier Joueur choisit une couleur, qui devient l\'atout. Elle l\'emporte sur toutes les autres. Si une personne n\'a pas de carte de la couleur du pli, elle doit obligatoirement poser un atout si elle en a. Si d\'autres atouts sont joués durant le pli, ils doivent être de valeur supérieure aux précédents.\nChaque personne marque $points points par pli remporté.';
  }

  @override
  String rulesTrumpsDetailed(String player, int points) {
    return '$player choisit une couleur, qui devient l\'atout. Elle l\'emporte sur toutes les autres.\n$player démarre le premier pli, ce qui détermine sa couleur. Si une personne n\'a pas de carte de la couleur du pli, elle doit obligatoirement poser un atout si elle en a. Si d\'autres atouts sont joués durant le pli, ils doivent être de valeur supérieure aux précédents.\nLa personne ayant posé l\'atout le plus élevé, ou à défaut la carte de la couleur demandée la plus élevée, remporte le pli. Elle démarre le pli suivant.\n\nChaque personne marque $points points par pli remporté.';
  }

  @override
  String get salad => 'Salade';

  @override
  String get saladScoresSubtitle => 'Quel est le score de chaque contrat ?';

  @override
  String get saveAndLeave => 'Sauvegarder et quitter';

  @override
  String get scores => 'Scores';

  @override
  String get scoresByContract => 'Scores par contrat';

  @override
  String get scoresNotValid => 'Scores incorrects';

  @override
  String seePreviousGame(String players) {
    return 'Revoir la partie précédente avec $players ?';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get startGame => 'Démarrer une partie';

  @override
  String get table => 'La table';

  @override
  String get total => 'Total';

  @override
  String get trick => 'pli';

  @override
  String get trumps => 'Atouts';

  @override
  String get unfold => 'Déplier les choix';

  @override
  String get validate => 'Valider';

  @override
  String get validateScores => 'Valider les scores';

  @override
  String whoWonItem(String item) {
    return 'Qui a remporté le $item ?';
  }

  @override
  String get worstEnnemy => 'Pire adversaire';
}
