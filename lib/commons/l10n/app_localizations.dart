import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'A propos'**
  String get about;

  /// No description provided for @aboutLea.
  ///
  /// In fr, this message translates to:
  /// **'Léa LOUESDON, créatrice des éléments graphiques'**
  String get aboutLea;

  /// No description provided for @aboutOceane.
  ///
  /// In fr, this message translates to:
  /// **'Océane GILLARD, chargée du développement de l\'application'**
  String get aboutOceane;

  /// No description provided for @aboutTheApp.
  ///
  /// In fr, this message translates to:
  /// **'L\'application Score Barbu est développée par des passionnées qui ont à coeur de répondre au mieux aux besoins des joueurs de Barbu !'**
  String get aboutTheApp;

  /// No description provided for @aboutTheTeam.
  ///
  /// In fr, this message translates to:
  /// **'L\'équipe est composée de : '**
  String get aboutTheTeam;

  /// No description provided for @accept.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get accept;

  /// No description provided for @ace.
  ///
  /// In fr, this message translates to:
  /// **'as'**
  String get ace;

  /// No description provided for @activateContract.
  ///
  /// In fr, this message translates to:
  /// **'Activer le contrat'**
  String get activateContract;

  /// No description provided for @addItem.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter {item, select, dame{une} other{un}} {item}'**
  String addItem(String item);

  /// No description provided for @alertCannotActivateSalad.
  ///
  /// In fr, this message translates to:
  /// **'Activation impossible'**
  String get alertCannotActivateSalad;

  /// No description provided for @alertCannotActivateSaladDetails.
  ///
  /// In fr, this message translates to:
  /// **'La salade doit posséder au moins un contrat à jouer pour être activée.'**
  String get alertCannotActivateSaladDetails;

  /// No description provided for @alertContractPlayed.
  ///
  /// In fr, this message translates to:
  /// **'Le contrat a déjà été joué'**
  String get alertContractPlayed;

  /// No description provided for @alertContractPlayedBy.
  ///
  /// In fr, this message translates to:
  /// **'Le contrat a déjà été joué par {players}. S\'il est désactivé il sera supprimé de la partie et {nbPlayers, plural, =1{ce joueur devra} other{ces joueurs devront}} choisir un contrat supplémentaire en fin de partie.'**
  String alertContractPlayedBy(String players, int nbPlayers);

  /// No description provided for @alertExistingGame.
  ///
  /// In fr, this message translates to:
  /// **'Une partie sauvegardée existe'**
  String get alertExistingGame;

  /// No description provided for @alertSaladContractPlayedBy.
  ///
  /// In fr, this message translates to:
  /// **'Le contrat a déjà été joué par {players}. Toute modification dans les paramètres de ce contrat aura des répercussions sur les contrats sauvegardés.'**
  String alertSaladContractPlayedBy(String players);

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Le Barbu'**
  String get appName;

  /// No description provided for @appTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème de l\'application'**
  String get appTheme;

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Score Barbu'**
  String get appTitle;

  /// No description provided for @appVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @askForFeedback.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez détecté un problème ou avez une suggestion d\'amélioration ? Vous pouvez nous le signaler par mail :'**
  String get askForFeedback;

  /// No description provided for @availableColor.
  ///
  /// In fr, this message translates to:
  /// **'Couleur disponible'**
  String get availableColor;

  /// No description provided for @avatar.
  ///
  /// In fr, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @barbu.
  ///
  /// In fr, this message translates to:
  /// **'Barbu'**
  String get barbu;

  /// No description provided for @bestFriend.
  ///
  /// In fr, this message translates to:
  /// **'Meilleur ami'**
  String get bestFriend;

  /// No description provided for @bug.
  ///
  /// In fr, this message translates to:
  /// **'Un bug'**
  String get bug;

  /// No description provided for @cardInterval.
  ///
  /// In fr, this message translates to:
  /// **'{firstCard} à {lastCard}'**
  String cardInterval(String firstCard, String lastCard);

  /// No description provided for @cardsOrder.
  ///
  /// In fr, this message translates to:
  /// **'Les as sont les cartes les plus fortes. Avant de jouer il faut conserver les cartes les plus élevées jusqu\'à obtenir le nombre requis.'**
  String get cardsOrder;

  /// No description provided for @cardsToKeep.
  ///
  /// In fr, this message translates to:
  /// **'Conserver les cartes'**
  String get cardsToKeep;

  /// No description provided for @cardsToKeepForPlayers.
  ///
  /// In fr, this message translates to:
  /// **'A {nbPlayers} joueurs, il faut donc {nbDecks, plural, =1{} other{prendre {nbDecks} paquets de cartes et }}conserver uniquement les cartes : {cards}.'**
  String cardsToKeepForPlayers(int nbPlayers, int nbDecks, String cards);

  /// No description provided for @changesSaved.
  ///
  /// In fr, this message translates to:
  /// **'Modifications sauvegardées'**
  String get changesSaved;

  /// No description provided for @changesSavedDetails.
  ///
  /// In fr, this message translates to:
  /// **'Les changements ont été sauvegardés et sont effectifs dès maintenant.'**
  String get changesSavedDetails;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @color.
  ///
  /// In fr, this message translates to:
  /// **'Couleur'**
  String get color;

  /// No description provided for @confirmStartGame.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la création d\'une nouvelle partie ? Si oui, la partie précédente avec {players} sera perdue.'**
  String confirmStartGame(String players);

  /// No description provided for @contact.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contactByMail.
  ///
  /// In fr, this message translates to:
  /// **'Contacter par mail'**
  String get contactByMail;

  /// No description provided for @contactReason.
  ///
  /// In fr, this message translates to:
  /// **'Que souhaitez-vous signaler ?'**
  String get contactReason;

  /// No description provided for @contractPoints.
  ///
  /// In fr, this message translates to:
  /// **'Points du contrat'**
  String get contractPoints;

  /// No description provided for @contracts.
  ///
  /// In fr, this message translates to:
  /// **'Contrats'**
  String get contracts;

  /// No description provided for @contractsOf.
  ///
  /// In fr, this message translates to:
  /// **'Contrats de {player}'**
  String contractsOf(String player);

  /// No description provided for @contractsRules.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu du Barbu comporte les contrats suivants :'**
  String get contractsRules;

  /// No description provided for @contractRulesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Règles {contract}'**
  String contractRulesTitle(String contract);

  /// No description provided for @contractsToPlay.
  ///
  /// In fr, this message translates to:
  /// **'Contrats à jouer'**
  String get contractsToPlay;

  /// No description provided for @createPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Créer les joueurs'**
  String get createPlayers;

  /// No description provided for @deactivate.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver'**
  String get deactivate;

  /// No description provided for @deactivatedForGame.
  ///
  /// In fr, this message translates to:
  /// **'Désactivé pour vos parties.'**
  String get deactivatedForGame;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @deletePlayer.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le joueur'**
  String get deletePlayer;

  /// No description provided for @domino.
  ///
  /// In fr, this message translates to:
  /// **'Réussite'**
  String get domino;

  /// No description provided for @dominoScoreSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Qui a fini {rank} ?'**
  String dominoScoreSubtitle(String rank);

  /// No description provided for @endGame.
  ///
  /// In fr, this message translates to:
  /// **'Fin de partie'**
  String get endGame;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get english;

  /// No description provided for @errorAddPoints.
  ///
  /// In fr, this message translates to:
  /// **'Ajout de points impossible'**
  String get errorAddPoints;

  /// No description provided for @errorAddPointsDetails.
  ///
  /// In fr, this message translates to:
  /// **'Le nombre de {item} dépasse le nombre d\'éléments pouvant être remporté, fixé à {nbItems}.'**
  String errorAddPointsDetails(String item, int nbItems);

  /// No description provided for @errorDomino.
  ///
  /// In fr, this message translates to:
  /// **'Tous les joueurs n\'ont pas été classés.'**
  String get errorDomino;

  /// No description provided for @errorLaunchGame.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lancer une partie'**
  String get errorLaunchGame;

  /// No description provided for @errorLaunchGameDetails.
  ///
  /// In fr, this message translates to:
  /// **'Tous les contrats sont désactivés dans les paramètres. Il faut au moins un contrat activé pour pouvoir jouer.'**
  String get errorLaunchGameDetails;

  /// No description provided for @errorNbItems.
  ///
  /// In fr, this message translates to:
  /// **'Le nombre d\'éléments ajoutés ne correspond pas au nombre attendu. Veuillez réessayer.'**
  String get errorNbItems;

  /// No description provided for @feature.
  ///
  /// In fr, this message translates to:
  /// **'Une suggestion'**
  String get feature;

  /// No description provided for @fold.
  ///
  /// In fr, this message translates to:
  /// **'Replier les choix'**
  String get fold;

  /// No description provided for @forGameAt.
  ///
  /// In fr, this message translates to:
  /// **'Pour une partie à'**
  String get forGameAt;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @fromTheDeck.
  ///
  /// In fr, this message translates to:
  /// **'{nbDecks, plural, =1{du paquet} other{de {nbDecks} paquets}}.'**
  String fromTheDeck(int nbDecks);

  /// No description provided for @gamePrinciple.
  ///
  /// In fr, this message translates to:
  /// **'Principe du jeu'**
  String get gamePrinciple;

  /// No description provided for @gamePrincipleDetails.
  ///
  /// In fr, this message translates to:
  /// **'Ce jeu de plis est composé de 7 contrats devant être réalisés par tous les joueurs. Chaque contrat possède des règles particulières, qui seront appliquées durant la manche de jeu.\nLa partie se termine lorsque tous les joueurs ont réalisé l\'ensemble des contrats.'**
  String get gamePrincipleDetails;

  /// No description provided for @gameRound.
  ///
  /// In fr, this message translates to:
  /// **'Manche de jeu'**
  String get gameRound;

  /// No description provided for @gameRoundRules.
  ///
  /// In fr, this message translates to:
  /// **'Distribuer les cartes entre les joueurs : chacun doit en avoir 8.*Le premier joueur choisit le contrat qu\'il souhaite jouer et l\'annonce aux autres joueurs.*Il démarre le pli en posant une carte, qui détermine la couleur du pli.*Chaque joueur pose une carte dans le sens des aiguilles d\'une montre.*Si un joueur ne possède pas de carte de la couleur demandée, il peut poser n\'importe quelle carte de son paquet. La valeur de cette carte sera alors considérée comme nulle.*A la fin du tour, le joueur ayant posé la carte de la plus grande valeur emporte le pli. C\'est lui qui démarrera le pli suivant.*La manche s\'arrête lorsque les joueurs ont joué toutes leurs cartes.*Les points sont ensuite comptés selon le contrat choisi par le premier joueur.*Le joueur à la gauche du premier joueur précédent démarre la manche suivante.'**
  String get gameRoundRules;

  /// No description provided for @gameSaved.
  ///
  /// In fr, this message translates to:
  /// **'Partie sauvegardée'**
  String get gameSaved;

  /// No description provided for @go.
  ///
  /// In fr, this message translates to:
  /// **'C\'est parti !'**
  String get go;

  /// No description provided for @goHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get goHome;

  /// No description provided for @heart.
  ///
  /// In fr, this message translates to:
  /// **'coeur'**
  String get heart;

  /// No description provided for @hintDarkMode.
  ///
  /// In fr, this message translates to:
  /// **'mode sombre'**
  String get hintDarkMode;

  /// No description provided for @hintLightMode.
  ///
  /// In fr, this message translates to:
  /// **'mode clair'**
  String get hintLightMode;

  /// No description provided for @hintForDarkMode.
  ///
  /// In fr, this message translates to:
  /// **'passer en mode sombre'**
  String get hintForDarkMode;

  /// No description provided for @hintForLightMode.
  ///
  /// In fr, this message translates to:
  /// **'passer en mode clair'**
  String get hintForLightMode;

  /// No description provided for @invertScore.
  ///
  /// In fr, this message translates to:
  /// **'Inversion du score'**
  String get invertScore;

  /// No description provided for @invertScoreDetails.
  ///
  /// In fr, this message translates to:
  /// **'Si un joueur remporte tout, son score devient négatif.'**
  String get invertScoreDetails;

  /// No description provided for @jack.
  ///
  /// In fr, this message translates to:
  /// **'valet'**
  String get jack;

  /// No description provided for @keep.
  ///
  /// In fr, this message translates to:
  /// **'Conserver'**
  String get keep;

  /// No description provided for @king.
  ///
  /// In fr, this message translates to:
  /// **'roi'**
  String get king;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @loadGame.
  ///
  /// In fr, this message translates to:
  /// **'Charger une partie'**
  String get loadGame;

  /// No description provided for @loadGameIndication.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez \"Charger une partie\" pour la poursuivre.'**
  String get loadGameIndication;

  /// No description provided for @loadPreviousGame.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre la partie précédente avec {players} ?'**
  String loadPreviousGame(String players);

  /// No description provided for @modify.
  ///
  /// In fr, this message translates to:
  /// **'Modification {contract}'**
  String modify(String contract);

  /// No description provided for @modifyContractsSettings.
  ///
  /// In fr, this message translates to:
  /// **'Les contrats sont modifiables dans la page de paramètres, pour personnaliser leurs points et variations.'**
  String get modifyContractsSettings;

  /// No description provided for @modifyPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le joueur'**
  String get modifyPlayer;

  /// No description provided for @modifySettings.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les paramètres'**
  String get modifySettings;

  /// No description provided for @moreInfo.
  ///
  /// In fr, this message translates to:
  /// **'Plus d\'informations'**
  String get moreInfo;

  /// No description provided for @nbCardsRules.
  ///
  /// In fr, this message translates to:
  /// **'Le jeu se joue avec {nbCards} cartes ({nbPlayers} × 8).'**
  String nbCardsRules(int nbCards, int nbPlayers);

  /// No description provided for @nbItemsByPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de {item}s par joueur'**
  String nbItemsByPlayer(String item);

  /// No description provided for @next.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// No description provided for @noGameFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie trouvée'**
  String get noGameFound;

  /// No description provided for @noGameFoundDetails.
  ///
  /// In fr, this message translates to:
  /// **'La partie précédente n\'a pas été retrouvée. Lancement d\'une nouvelle partie.'**
  String get noGameFoundDetails;

  /// No description provided for @noHearts.
  ///
  /// In fr, this message translates to:
  /// **'Sans coeurs'**
  String get noHearts;

  /// No description provided for @noLastTrick.
  ///
  /// In fr, this message translates to:
  /// **'Dernier'**
  String get noLastTrick;

  /// No description provided for @noQueens.
  ///
  /// In fr, this message translates to:
  /// **'Sans dames'**
  String get noQueens;

  /// No description provided for @noTricks.
  ///
  /// In fr, this message translates to:
  /// **'Sans plis'**
  String get noTricks;

  /// No description provided for @other.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get other;

  /// No description provided for @playerNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Nom du joueur {nb}'**
  String playerNameHint(int nb);

  /// No description provided for @playerTurn.
  ///
  /// In fr, this message translates to:
  /// **'Tour de'**
  String get playerTurn;

  /// No description provided for @player.
  ///
  /// In fr, this message translates to:
  /// **'joueur'**
  String get player;

  /// No description provided for @players.
  ///
  /// In fr, this message translates to:
  /// **'joueurs'**
  String get players;

  /// No description provided for @playersOrder.
  ///
  /// In fr, this message translates to:
  /// **'Ordre des joueurs'**
  String get playersOrder;

  /// No description provided for @points.
  ///
  /// In fr, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @pointsBy.
  ///
  /// In fr, this message translates to:
  /// **'Points par {item}'**
  String pointsBy(String item);

  /// No description provided for @pointsForNbPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Points à {nb} joueurs'**
  String pointsForNbPlayers(int nb);

  /// No description provided for @prepareGame.
  ///
  /// In fr, this message translates to:
  /// **'Préparer la partie'**
  String get prepareGame;

  /// No description provided for @prepareGameRules.
  ///
  /// In fr, this message translates to:
  /// **'Préparation du jeu'**
  String get prepareGameRules;

  /// No description provided for @presentGame.
  ///
  /// In fr, this message translates to:
  /// **'Le barbu est un jeu pour 3 à 6 joueurs se jouant avec un jeu de cartes. Il peut aussi se jouer jusqu\'à 10 joueurs, avec 2 paquets de cartes. L\'objectif est de remporter le moins de points possible.'**
  String get presentGame;

  /// No description provided for @previous.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get previous;

  /// No description provided for @queen.
  ///
  /// In fr, this message translates to:
  /// **'dame'**
  String get queen;

  /// No description provided for @ranking.
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get ranking;

  /// No description provided for @rateApp.
  ///
  /// In fr, this message translates to:
  /// **'Evaluer l\'application'**
  String get rateApp;

  /// No description provided for @refuseLoadGame.
  ///
  /// In fr, this message translates to:
  /// **'Non, nouvelle partie'**
  String get refuseLoadGame;

  /// No description provided for @refuseStartGame.
  ///
  /// In fr, this message translates to:
  /// **'Non, reprendre la partie'**
  String get refuseStartGame;

  /// No description provided for @reportBug.
  ///
  /// In fr, this message translates to:
  /// **'Signaler un bug'**
  String get reportBug;

  /// No description provided for @reportBugMail.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour,\n\nJe souhaiterai signaler un bug rencontré sur l’application. Voici les détails :\n\n- Description du bug (expliquez ce qu\'il s’est passé, ce que vous faisiez avant que le problème apparaisse, etc.) :\n\n- Étapes pour reproduire le bug (indiquez les actions à suivre pour que le problème se reproduise) : \n\n- Comportement attendu (ce qui aurait dû se passer) :'**
  String get reportBugMail;

  /// No description provided for @requestFeature.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une amélioration'**
  String get requestFeature;

  /// No description provided for @requestFeatureMail.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour,\n\nJe souhaiterai proposer une nouvelle fonctionnalité pour l\'application, afin de...'**
  String get requestFeatureMail;

  /// No description provided for @rules.
  ///
  /// In fr, this message translates to:
  /// **'Règles du jeu'**
  String get rules;

  /// No description provided for @rulesBarbu.
  ///
  /// In fr, this message translates to:
  /// **'Le joueur emportant le roi de coeur (Barbu) marque {points} points.'**
  String rulesBarbu(int points);

  /// No description provided for @rulesBarbuInSalad.
  ///
  /// In fr, this message translates to:
  /// **'- le roi de coeur (Barbu) vaut {points} points'**
  String rulesBarbuInSalad(int points);

  /// No description provided for @rulesDomino.
  ///
  /// In fr, this message translates to:
  /// **'Contrairement aux autres contrats, la réussite n\'est pas un contrat à plis. L\'objectif de ce contrat est de poser toutes les cartes du jeu sur la table, triées par couleur et dans l\'ordre croissant.\nLe joueur choisissant ce contrat détermine la valeur d\'ouverture de la réussite (par exemple le valet). S\'il possède une carte de cette valeur, il la pose sur la table, sinon il passe son tour.\nLe joueur suivant peut ensuite poser une carte de même couleur et de valeur directement supérieure ou inférieure (donc le 10 ou la dame de la couleur précédente). Il peut aussi poser une carte de la valeur d\'ouverture, dans une autre couleur. S\'il joue un as, il peut rejouer. S\'il ne peut pas poser de carte, il indique qu\'il passe.\nLe jeu se poursuit ainsi jusqu\'à ce que tous les joueurs aient fini leur paquet. L\'objectif est de poser toutes ses cartes le plus rapidement possible, pour marquer un minimum de points.'**
  String get rulesDomino;

  /// No description provided for @rulesDominoDetailed.
  ///
  /// In fr, this message translates to:
  /// **'L\'objectif de la réussite est de poser toutes les cartes du jeu sur la table, triées par couleur et dans l\'ordre croissant.\n{player} détermine la valeur d\'ouverture de la réussite (par exemple le valet), et pose une carte de cette valeur s\'il y en a dans son jeu.\nLe joueur suivant pose ensuite une carte de même couleur et de valeur directement supérieure ou inférieure (donc le 10 ou la dame de la couleur précédente), ou une carte de la valeur d\'ouverture. S\'il joue un as, il peut rejouer. S\'il ne peut pas poser de carte, il indique qu\'il passe.\nLe jeu se poursuit ainsi jusqu\'à ce que tous les joueurs aient fini leur paquet. Les points marqués dépendent de l\'ordre de fin des joueurs, et sont distribués comme suit :\n{points}'**
  String rulesDominoDetailed(String player, String points);

  /// No description provided for @rulesNoHearts.
  ///
  /// In fr, this message translates to:
  /// **'Chaque joueur marque {points} points par coeur remporté.'**
  String rulesNoHearts(int points);

  /// No description provided for @rulesNoHeartsInSalad.
  ///
  /// In fr, this message translates to:
  /// **'- chaque coeur vaut {points} points'**
  String rulesNoHeartsInSalad(int points);

  /// No description provided for @rulesNoQueens.
  ///
  /// In fr, this message translates to:
  /// **'Chaque joueur marque {points} points par dame remportée.'**
  String rulesNoQueens(int points);

  /// No description provided for @rulesNoQueensInSalad.
  ///
  /// In fr, this message translates to:
  /// **'- chaque dame vaut {points} points'**
  String rulesNoQueensInSalad(int points);

  /// No description provided for @rulesNoLastTrick.
  ///
  /// In fr, this message translates to:
  /// **'Le joueur emportant le dernier pli marque {points} points.'**
  String rulesNoLastTrick(int points);

  /// No description provided for @rulesNoLastTrickInSalad.
  ///
  /// In fr, this message translates to:
  /// **'- le dernier pli vaut {points} points'**
  String rulesNoLastTrickInSalad(int points);

  /// No description provided for @rulesNoTricks.
  ///
  /// In fr, this message translates to:
  /// **'Chaque joueur marque {points} points par pli remporté.'**
  String rulesNoTricks(int points);

  /// No description provided for @rulesNoTricksInSalad.
  ///
  /// In fr, this message translates to:
  /// **'- chaque pli vaut {points} points'**
  String rulesNoTricksInSalad(int points);

  /// No description provided for @rulesSalad.
  ///
  /// In fr, this message translates to:
  /// **'Ce contrat est une combinaison des contrats {contracts}.\nC\'est le contrat qui peut faire marquer le plus de points puisque les points de chaque contrat s\'additionnent.'**
  String rulesSalad(String contracts);

  /// No description provided for @rulesSaladDetailed.
  ///
  /// In fr, this message translates to:
  /// **'Ce contrat est une combinaison des contrats {contracts}. Les points sont comptés comme suit :\n{itemWithPoints}'**
  String rulesSaladDetailed(String contracts, String itemWithPoints);

  /// No description provided for @rulesTrickRound.
  ///
  /// In fr, this message translates to:
  /// **'{player} démarre le premier pli, et détermine ainsi sa couleur.\nLe joueur ayant posé la carte de cette couleur la plus élevée remporte le pli. Il démarre le pli suivant.'**
  String rulesTrickRound(String player);

  /// No description provided for @salad.
  ///
  /// In fr, this message translates to:
  /// **'Salade'**
  String get salad;

  /// No description provided for @saladScoresSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Quel est le score de chaque contrat ?'**
  String get saladScoresSubtitle;

  /// No description provided for @saveAndLeave.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder et quitter'**
  String get saveAndLeave;

  /// No description provided for @scores.
  ///
  /// In fr, this message translates to:
  /// **'Scores'**
  String get scores;

  /// No description provided for @scoresByContract.
  ///
  /// In fr, this message translates to:
  /// **'Scores par contrat'**
  String get scoresByContract;

  /// No description provided for @scoresNotValid.
  ///
  /// In fr, this message translates to:
  /// **'Scores incorrects'**
  String get scoresNotValid;

  /// No description provided for @seePreviousGame.
  ///
  /// In fr, this message translates to:
  /// **'Revoir la partie précédente avec {players} ?'**
  String seePreviousGame(String players);

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @startGame.
  ///
  /// In fr, this message translates to:
  /// **'Démarrer une partie'**
  String get startGame;

  /// No description provided for @table.
  ///
  /// In fr, this message translates to:
  /// **'La table'**
  String get table;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @trick.
  ///
  /// In fr, this message translates to:
  /// **'pli'**
  String get trick;

  /// No description provided for @unfold.
  ///
  /// In fr, this message translates to:
  /// **'Déplier les choix'**
  String get unfold;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @validateScores.
  ///
  /// In fr, this message translates to:
  /// **'Valider les scores'**
  String get validateScores;

  /// No description provided for @whoWonItem.
  ///
  /// In fr, this message translates to:
  /// **'Qui a remporté le {item} ?'**
  String whoWonItem(String item);

  /// No description provided for @withdrawItem.
  ///
  /// In fr, this message translates to:
  /// **'Retirer {item, select, dame{une} other{un}} {item}'**
  String withdrawItem(String item);

  /// No description provided for @worstEnnemy.
  ///
  /// In fr, this message translates to:
  /// **'Pire ennemi'**
  String get worstEnnemy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
