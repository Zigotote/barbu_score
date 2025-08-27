// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get accept => 'Oui';

  @override
  String get ace => 'as';

  @override
  String get activateContract => 'Activer le contrat';

  @override
  String addItem(String item) {
    return 'Ajouter $item';
  }

  @override
  String get alertCannotActivateSalad => 'Activation impossible';

  @override
  String get alertCannotActivateSaladDetails =>
      'La salade doit posséder au moins un contrat à jouer pour être activée.';

  @override
  String get alertContractPlayed => 'Le contrat a déjà été joué';

  @override
  String alertContractPlayedBy(String players, int nbPlayers) {
    String _temp0 = intl.Intl.pluralLogic(
      nbPlayers,
      locale: localeName,
      other: 'ces joueurs devront',
      one: 'ce joueur devra',
    );
    return 'Le contrat a déjà été joué par $players. S\'il est désactivé il sera supprimé de la partie et $_temp0 choisir un contrat supplémentaire en fin de partie.';
  }

  @override
  String get alertExistingGame => 'Une partie sauvegardée existe';

  @override
  String alertSaladContractPlayedBy(String players) {
    return 'Le contrat a déjà été joué par $players. Toute modification dans les paramètres de ce contrat aura des répercussions sur les contrats sauvegardés.';
  }

  @override
  String get appName => 'Le Barbu';

  @override
  String get appTheme => 'Thème de l\'application';

  @override
  String get appTitle => 'Score Barbu';

  @override
  String get availableColor => 'Couleur disponible';

  @override
  String get avatar => 'Avatar';

  @override
  String get barbu => 'Barbu';

  @override
  String get bestFriend => 'Meilleur ami';

  @override
  String get cardsOrder =>
      'Les as sont les cartes les plus fortes. Avant de jouer il faut conserver les cartes les plus fortes jusqu\'à obtenir le nombre requis.';

  @override
  String get cardsToKeep => 'Conserver les cartes';

  @override
  String cardsToKeepForPlayers(int nbPlayers, int nbDecks, String cards) {
    String _temp0 = intl.Intl.pluralLogic(
      nbDecks,
      locale: localeName,
      other: 'prendre $nbDecks paquets de cartes et ',
      one: '',
    );
    return 'A $nbPlayers joueurs, il faut donc ${_temp0}conserver uniquement les cartes : $cards.';
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
    return 'Confirmer la création d\'une nouvelle partie ? Si oui, la partie précédente avec $players sera perdue.';
  }

  @override
  String get contractPoints => 'Points du contrat';

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
  String get createPlayers => 'Créer les joueurs';

  @override
  String get deactivate => 'Désactiver';

  @override
  String get deactivatedForGame => 'Désactivé pour vos parties.';

  @override
  String get delete => 'Supprimer';

  @override
  String get deletePlayer => 'Supprimer le joueur';

  @override
  String get domino => 'Réussite';

  @override
  String get dominoScoreSubtitle => 'Quel est l\'ordre des joueurs ?';

  @override
  String get endGame => 'Fin de partie';

  @override
  String get english => 'Anglais';

  @override
  String get errorAddPoints => 'Ajout de points impossible';

  @override
  String errorAddPointsDetails(String item, int nbItems) {
    return 'Le nombre de $item dépasse le nombre d\'éléments pouvant être remporté, fixé à $nbItems.';
  }

  @override
  String get errorDomino => 'Tous les joueurs n\'ont pas été classés.';

  @override
  String get errorLaunchGame => 'Impossible de lancer une partie';

  @override
  String get errorLaunchGameDetails =>
      'Tous les contrats sont désactivés dans les paramètres. Il faut au moins un contrat activé pour pouvoir jouer.';

  @override
  String get errorNbItems =>
      'Le nombre d\'éléments ajoutés ne correspond pas au nombre attendu. Veuillez réessayer.';

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
  String get gamePrinciple => 'Principe du jeu';

  @override
  String get gamePrincipleDetails =>
      'Ce jeu de plis est composé de 7 contrats devant être réalisés par tous les joueurs. Chaque contrat possède des règles particulières, qui seront appliquées durant la manche de jeu.\nLa partie se termine lorsque tous les joueurs ont réalisé l\'ensemble des contrats.';

  @override
  String get gameRound => 'Manche de jeu';

  @override
  String get gameRoundRules =>
      'Distribuer les cartes entre les joueurs : chacun doit en avoir 8.*Le premier joueur choisit le contrat qu\'il souhaite jouer et l\'annonce aux autres joueurs.*Il démarre le pli en posant une carte, qui détermine la couleur du pli.*Chaque joueur pose une carte dans le sens des aiguilles d\'une montre.*Si un joueur ne possède pas de carte de la couleur demandée, il peut poser n\'importe quelle carte de son paquet. La valeur de cette carte sera alors considérée comme nulle.*A la fin du tour, le joueur ayant posé la carte de la plus grande valeur emporte le pli. C\'est lui qui démarrera le pli suivant.*La manche s\'arrête lorsque les joueurs ont joué toutes leurs cartes.*Les points sont ensuite comptés selon le contrat choisi par le premier joueur.*Le joueur à la gauche du premier joueur précédent démarre la manche suivante.';

  @override
  String get gameSaved => 'Partie sauvegardée';

  @override
  String get go => 'C\'est parti !';

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
      'Si un joueur remporte tout, son score devient négatif.';

  @override
  String get jack => 'valet';

  @override
  String get keep => 'Conserver';

  @override
  String get king => 'roi';

  @override
  String get language => 'Langue';

  @override
  String get loadGame => 'Charger une partie';

  @override
  String get loadGameIndication =>
      'Sélectionnez \"Charger une partie\" pour la poursuivre.';

  @override
  String loadPreviousGame(String players) {
    return 'Reprendre la partie précédente avec $players ?';
  }

  @override
  String modify(String contract) {
    return 'Modification $contract';
  }

  @override
  String get modifyContractsSettings =>
      'Les contrats sont modifiables dans la page de paramètres, pour personnaliser leurs points et variations.';

  @override
  String get modifyPlayer => 'Modifier le joueur';

  @override
  String get modifySettings => 'Modifier les paramètres';

  @override
  String nbCardsRules(int nbCards, int nbPlayers) {
    return 'Le jeu se joue avec $nbCards cartes ($nbPlayers × 8).';
  }

  @override
  String nbItemsByPlayer(String item) {
    return 'Nombre de ${item}s par joueur';
  }

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
  String playerNameHint(int nb) {
    return 'Nom du joueur $nb';
  }

  @override
  String get playerTurn => 'Tour de';

  @override
  String get player => 'joueur';

  @override
  String get players => 'joueurs';

  @override
  String get points => 'points';

  @override
  String pointsBy(String item) {
    return 'Points par $item';
  }

  @override
  String pointsForNbPlayers(int nb) {
    return 'Points à $nb joueurs';
  }

  @override
  String get prepareGame => 'Préparer la partie';

  @override
  String get prepareGameRules => 'Préparation du jeu';

  @override
  String get presentGame =>
      'Le barbu est un jeu pour 3 à 6 joueurs se jouant avec un jeu de cartes. L\'objectif est de remporter le moins de points possible.';

  @override
  String get previous => 'Précédent';

  @override
  String get queen => 'dame';

  @override
  String get ranking => 'Classement';

  @override
  String get refuseLoadGame => 'Non, nouvelle partie';

  @override
  String get refuseStartGame => 'Non, reprendre la partie';

  @override
  String get rules => 'Règles du jeu';

  @override
  String rulesBarbu(int points) {
    return 'Le joueur emportant le roi de coeur (Barbu) marque $points points.';
  }

  @override
  String rulesBarbuInSalad(int points) {
    return '- le roi de coeur (Barbu) vaut $points points';
  }

  @override
  String get rulesDomino =>
      'Contrairement aux autres contrats, la réussite n\'est pas un contrat à plis. L\'objectif de ce contrat est de poser toutes les cartes du jeu sur la table, triées par couleur et dans l\'ordre croissant.\nLe joueur choisissant ce contrat détermine la valeur d\'ouverture de la réussite (par exemple le valet). S\'il possède une carte de cette valeur, il la pose sur la table, sinon il passe son tour.\nLe joueur suivant peut ensuite poser une carte de même couleur et de valeur directement supérieure ou inférieure (donc le 10 ou la dame de la couleur précédente). Il peut aussi poser une carte de la valeur d\'ouverture, dans une autre couleur. S\'il joue un as, il peut rejouer. S\'il ne peut pas poser de carte, il indique qu\'il passe.\nLe jeu se poursuit ainsi jusqu\'à ce que tous les joueurs aient fini leur paquet. L\'objectif est de poser toutes ses cartes le plus rapidement possible, pour marquer un minimum de points.';

  @override
  String rulesDominoDetailed(String player, String points) {
    return 'L\'objectif de la réussite est de poser toutes les cartes du jeu sur la table, triées par couleur et dans l\'ordre croissant.\n$player détermine la valeur d\'ouverture de la réussite (par exemple le valet), et pose une carte de cette valeur s\'il y en a dans son jeu.\nLe joueur suivant pose ensuite une carte de même couleur et de valeur directement supérieure ou inférieure (donc le 10 ou la dame de la couleur précédente), ou une carte de la valeur d\'ouverture. S\'il joue un as, il peut rejouer. S\'il ne peut pas poser de carte, il indique qu\'il passe.\nLe jeu se poursuit ainsi jusqu\'à ce que tous les joueurs aient fini leur paquet. Les points marqués dépendent de l\'ordre de fin des joueurs, et sont distribués comme suit :\n$points';
  }

  @override
  String rulesNoHearts(int points) {
    return 'Chaque joueur marque $points points par coeur remporté.';
  }

  @override
  String rulesNoHeartsInSalad(int points) {
    return '- chaque coeur vaut $points points';
  }

  @override
  String rulesNoQueens(int points) {
    return 'Chaque joueur marque $points points par dame remportée.';
  }

  @override
  String rulesNoQueensInSalad(int points) {
    return '- chaque dame vaut $points points';
  }

  @override
  String rulesNoLastTrick(int points) {
    return 'Le joueur emportant le dernier pli marque $points points.';
  }

  @override
  String rulesNoLastTrickInSalad(int points) {
    return '- le dernier pli vaut $points points';
  }

  @override
  String rulesNoTricks(int points) {
    return 'Chaque joueur marque $points points par pli remporté.';
  }

  @override
  String rulesNoTricksInSalad(int points) {
    return '- chaque pli vaut $points points';
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
    return '$player démarre le premier pli, et détermine ainsi sa couleur.\nLe joueur ayant posé la carte de cette couleur la plus élevée remporte le pli. Il démarre le pli suivant.';
  }

  @override
  String get salad => 'Salade';

  @override
  String get saladScoresSubtitle => 'Quel est le score de chaque contrat ?';

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
    return 'Revoir la partie précédente avec $players ?';
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
  String get unfold => 'Déplier les choix';

  @override
  String get validate => 'Valider';

  @override
  String get validateScores => 'Valider les scores';

  @override
  String whoWonItem(String item) {
    return 'Qui a remporté le $item ?';
  }

  @override
  String withdrawItem(String item) {
    return 'Retirer $item';
  }

  @override
  String get worstEnnemy => 'Pire ennemi';
}
