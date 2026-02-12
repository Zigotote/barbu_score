// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get aboutLea => 'Léa LOUESDON, creator of graphic elements';

  @override
  String get aboutOceane =>
      'Océane GILLARD, responsible for application development';

  @override
  String get aboutTheApp =>
      'The Score Barbu app is developed by enthusiasts who are committed to meeting the needs of Barbu players as best they can!';

  @override
  String get aboutTheTeam => 'The team consists of:';

  @override
  String get accept => 'Yes';

  @override
  String get ace => 'ace';

  @override
  String get activateContract => 'Activate contract';

  @override
  String get addCard => 'Add a card';

  @override
  String addItem(String item) {
    return 'Add one $item';
  }

  @override
  String get alertCannotActivateSalad => 'Cannot activate';

  @override
  String get alertCannotActivateSaladDetails =>
      'The salad must have at least one contract to be played to be activated.';

  @override
  String get alertContractPlayed => 'The contract has already been played';

  @override
  String alertContractPlayedBy(String players, int nbPlayers) {
    String _temp0 = intl.Intl.pluralLogic(
      nbPlayers,
      locale: localeName,
      other: 'these players will',
      one: 'this player will',
    );
    return 'The contract has already been played by $players. If it is deactivated, it will be removed from the game and $_temp0 have to choose an additional contract at the end of the game.';
  }

  @override
  String get alertExistingGame => 'A saved game exists';

  @override
  String alertSaladContractPlayedBy(String players) {
    return 'The contract has already been played by $players. Any changes in the settings of this contract will affect the saved contracts.';
  }

  @override
  String get and => 'and';

  @override
  String get application => 'Application';

  @override
  String get appName => 'The Barbu';

  @override
  String get appTheme => 'App theme';

  @override
  String get appTitle => 'Barbu Score';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get askForFeedback =>
      'Have you detected a problem or have a suggestion for improvement? You can report it to us by email:';

  @override
  String get availableColor => 'Available color';

  @override
  String get avatar => 'Avatar';

  @override
  String get back => 'Back';

  @override
  String get barbu => 'Barbu';

  @override
  String get bestFriend => 'Best friend';

  @override
  String get bug => 'A bug';

  @override
  String cardInterval(String firstCard, String lastCard) {
    return '$firstCard to $lastCard';
  }

  @override
  String get cardsOrder =>
      'Aces are the highest cards. Before playing, the strongest cards must be kept until the required number is reached.';

  @override
  String get cardsToKeep => 'Keep the cards';

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
      other: '$nbDecks decks',
      one: 'one deck',
    );
    return 'Before playing, keep the highest cards from $_temp0 of $nbCardsInDeck cards until you have the required number. With $nbPlayers players, you should therefore only keep the following cards: $cards';
  }

  @override
  String cardToKeepPartially(String nbCards, String card) {
    String _temp0 = intl.Intl.selectLogic(nbCards, {
      '1': '♣',
      '2': '♣♦',
      '3': '♣♦♠',
      '4': '♣♦',
      '5': '♣♦ and a ♠',
      '6': '♣♦♠',
      '7': '♣♦♠ and a ♥',
      'other': '',
    });
    return '$card$_temp0';
  }

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get changesSavedDetails =>
      'The changes have been saved and are effective immediately.';

  @override
  String get close => 'Close';

  @override
  String get color => 'Color';

  @override
  String confirmStartGame(String players) {
    return 'Confirm creation of a new game? If yes, the previous game with $players will be lost.';
  }

  @override
  String get contact => 'Contact';

  @override
  String get contactByMail => 'Contact by mail';

  @override
  String get contactReason => 'What would you like to report?';

  @override
  String get contractPoints => 'Contract points';

  @override
  String get contracts => 'Contracts';

  @override
  String contractsOf(String player) {
    return '$player\'s contracts';
  }

  @override
  String get contractsRules =>
      'The Barbu game includes the following contracts:';

  @override
  String contractRulesTitle(String contract) {
    return '$contract rules';
  }

  @override
  String get contractsToPlay => 'Contracts to play';

  @override
  String get createPlayers => 'Create players';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deactivatedForGame => 'Disabled for your games.';

  @override
  String decksOfCards(int nbDecks, int nbCards) {
    String _temp0 = intl.Intl.pluralLogic(
      nbDecks,
      locale: localeName,
      other: '$nbDecks decks',
      one: '1 deck',
    );
    return '$_temp0 of $nbCards cards.';
  }

  @override
  String get deckQuestion => 'Deck type';

  @override
  String get defaultNbTricks => '8 tricks';

  @override
  String get delete => 'Delete';

  @override
  String get deletePlayer => 'Delete player';

  @override
  String get domino => 'Domino';

  @override
  String dominoScoreSubtitle(String rank) {
    return 'Who finished $rank?';
  }

  @override
  String get endGame => 'End of game';

  @override
  String get english => 'English';

  @override
  String get errorAddItem => 'Unable to add item';

  @override
  String errorAddItemDetails(String item, int nbItems) {
    return 'The number of $item exceeds the number of items that can be won, fixed at $nbItems.';
  }

  @override
  String get errorDomino => 'Not all players have been ranked.';

  @override
  String get errorLaunchGame => 'Cannot start the game';

  @override
  String get errorLaunchGameDetails =>
      'All contracts are deactivated in the settings. At least one contract must be activated to play.';

  @override
  String get errorAddWithdrawnCard => 'Unable to add discarded card';

  @override
  String errorAddWithdrawnCardDetails(String item, int nbItems) {
    return 'The number of $item exceeds the number of cards in the discard pile, set at $nbItems.';
  }

  @override
  String get feature => 'A feature';

  @override
  String get fold => 'Collapse the choices';

  @override
  String get forGameAt => 'For a game of';

  @override
  String get french => 'French';

  @override
  String fromTheDeck(int nbDecks) {
    String _temp0 = intl.Intl.pluralLogic(
      nbDecks,
      locale: localeName,
      other: 'from $nbDecks decks',
      one: 'from the deck',
    );
    return '$_temp0.';
  }

  @override
  String get game => 'Game';

  @override
  String get gamePrinciple => 'Game principle';

  @override
  String get gamePrincipleDetails =>
      'This trick-taking game consists of different contracts that must be completed by all players. Each contract has specific rules that will be applied during the round of play.\nThe game ends when all players have completed all the contracts.';

  @override
  String get gameRound => 'Round of play';

  @override
  String get gameRoundRules =>
      'Distribute the same number of cards among the players.*The first player chooses the contract he wishes to play and announces it to the other players.*He starts the trick by playing a card, which determines the suit of the trick.*Each player plays a card in clockwise order.*If a player does not have a card of the required suit, they can play any card from their hand. The value of this card will be considered as null.*At the end of the round, the player who played the highest-value card wins the trick. He will start the next trick.*The round ends when all players have played all their cards.*Points are then counted according to the contract chosen by the first player.*The player to the left of the previous first player starts the next round.';

  @override
  String get gameSaved => 'Game saved';

  @override
  String get go => 'Let\'s go!';

  @override
  String get goal => 'Goal';

  @override
  String get goHome => 'Go back to home';

  @override
  String get heart => 'heart';

  @override
  String get hintDarkMode => 'dark mode';

  @override
  String get hintLightMode => 'light mode';

  @override
  String get hintForDarkMode => 'set dark mode';

  @override
  String get hintForLightMode => 'set light mode';

  @override
  String get invertScore => 'Invert score';

  @override
  String get invertScoreNegativeDetails =>
      'If a player wins all, their score becomes negative.';

  @override
  String get invertScorePositiveDetails =>
      'If a player wins all, their score becomes positive.';

  @override
  String get jack => 'jack';

  @override
  String get keep => 'Keep';

  @override
  String get king => 'king';

  @override
  String get language => 'Language';

  @override
  String get loadGame => 'Load a game';

  @override
  String get loadGameIndication => 'Select \"Load a game\" to continue.';

  @override
  String loadPreviousGame(String players) {
    return 'Resume the previous game with $players?';
  }

  @override
  String get lowest => 'Lowest';

  @override
  String get maxScore => 'Highest score';

  @override
  String get minScore => 'Lowest score';

  @override
  String get mix => 'Mix';

  @override
  String modify(String contract) {
    return 'Modify $contract';
  }

  @override
  String get modifyContractsSettings =>
      'The contracts can be modified on the settings page to customize their points and variations.';

  @override
  String get modifyPlayer => 'Modify player';

  @override
  String get modifySettings => 'Modify settings';

  @override
  String get moreInfo => 'More information';

  @override
  String nbCards(int nbCards) {
    return '$nbCards cards';
  }

  @override
  String nbCardsRules(int nbCards, int nbTricks) {
    return 'The game is played with $nbCards cards ($nbTricks cards by player).';
  }

  @override
  String nbDecksRules(int nbDecks, int nbCardsByDeck) {
    String _temp0 = intl.Intl.pluralLogic(
      nbDecks,
      locale: localeName,
      other: '$nbDecks decks',
      one: '1 deck',
    );
    return 'The game is played with $_temp0 of $nbCardsByDeck cards.';
  }

  @override
  String nbItemsByPlayer(String item) {
    return 'Number of ${item}s per player';
  }

  @override
  String get nbTricksTooltip =>
      'An optimized number of tricks means distributing all the cards in the deck evenly among the players.';

  @override
  String get nbTricksQuestion => 'Number of tricks';

  @override
  String get next => 'Next';

  @override
  String get noGameFound => 'No game found';

  @override
  String get noGameFoundDetails =>
      'The previous game was not found. Starting a new game.';

  @override
  String get noHearts => 'No hearts';

  @override
  String get noLastTrick => 'No last trick';

  @override
  String get noQueens => 'No queens';

  @override
  String get noTricks => 'No tricks';

  @override
  String get optimized => 'Optimized';

  @override
  String get other => 'Other';

  @override
  String playerNameHint(int nb) {
    return 'Name of player $nb';
  }

  @override
  String get playerTurn => 'Turn of';

  @override
  String get player => 'player';

  @override
  String get players => 'players';

  @override
  String get playersOrder => 'Player\'s order';

  @override
  String get points => 'points';

  @override
  String pointsBy(String item) {
    return 'Points by $item';
  }

  @override
  String pointsForNbPlayers(int nb) {
    return 'Points for $nb players';
  }

  @override
  String get prepareGame => 'Prepare the game';

  @override
  String get prepareGameRules => 'Game setup';

  @override
  String get presentGame => 'Barbu is a card game for 3 to 10 players.';

  @override
  String get presentGameGoalMaxScore =>
      'The goal is to score as many points as possible.';

  @override
  String get presentGameGoalMinScore =>
      'The goal is to score as few points as possible.';

  @override
  String get previous => 'Previous';

  @override
  String get queen => 'queen';

  @override
  String get randoms => 'Random';

  @override
  String get ranking => 'Ranking';

  @override
  String get rateApp => 'Rate app';

  @override
  String get refuseLoadGame => 'No, new game';

  @override
  String get refuseStartGame => 'No, resume game';

  @override
  String get reportBug => 'Report a bug';

  @override
  String get reportBugMail =>
      'Hello,\n\nI’d like to report a bug I encountered in the application. Please find the details below:\n\n- Bug description (describe what happened, what you were doing when the issue occurred, etc.): \n\n- Steps to reproduce (list the steps needed to make the issue happen again):\n\n- Expected behavior (describe what should have happened instead)';

  @override
  String get requestFeature => 'Request a feature';

  @override
  String get requestFeatureMail =>
      'Hello,\n\nI’d like to suggest a new feature for the application to be able to...';

  @override
  String get rules => 'Game rules';

  @override
  String rulesBarbu(int points) {
    return 'The player who wins the king of hearts (Barbu) scores $points points.';
  }

  @override
  String rulesBarbuInSalad(int points) {
    return '- the king of hearts (Barbu) is worth $points points';
  }

  @override
  String get rulesDomino =>
      'Unlike other contracts, Domino is not a trick-taking contract. The goal of this contract is to lay all the cards on the table, sorted by suit and in ascending order.\nThe player who chooses this contract determines the starting value of the sequence (for example, the jack). If they have a card of that value, they place it on the table; otherwise, they skip their turn.\nThe next player can then play a card of the same suit and of a value directly higher or lower (so the 10 or the queen of the same suit). They can also play another card of the starting value in a different suit. If they play an ace, they may play again. If they cannot play a card, they pass.\nThe game continues in this manner until all players have finished their hands. The objective is to play all your cards as quickly as possible.';

  @override
  String rulesDominoDetailed(String player, String points) {
    return 'The goal of Domino is to lay all the cards on the table, sorted by suit and in ascending order.\n$player determines the starting value of the sequence (for example, the jack), and plays a card of that value if they have one.\nThe next player then plays a card of the same suit and of a value directly higher or lower (so the 10 or the queen of the same suit), or a card of the starting value in a different suit. If they play an ace, they may play again. If they cannot play a card, they pass.\nThe game continues in this manner until all players have finished their hands. Points are awarded based on the order in which players finish, distributed as follows:\n$points';
  }

  @override
  String rulesNoHearts(int points) {
    return 'Each player scores $points points per heart won.';
  }

  @override
  String rulesNoHeartsInSalad(int points) {
    return '- each heart is worth $points points';
  }

  @override
  String rulesNoQueens(int points) {
    return 'Each player scores $points points per queen won.';
  }

  @override
  String rulesNoQueensInSalad(int points) {
    return '- each queen is worth $points points';
  }

  @override
  String rulesNoLastTrick(int points) {
    return 'The player who wins the last trick scores $points points.';
  }

  @override
  String rulesNoLastTrickInSalad(int points) {
    return '- the last trick is worth $points points';
  }

  @override
  String rulesNoTricks(int points) {
    return 'Each player scores $points points per trick won.';
  }

  @override
  String rulesNoTricksInSalad(int points) {
    return '- each trick is worth $points points';
  }

  @override
  String rulesSalad(String contracts) {
    return 'This contract is a combination of the $contracts contracts.\nIt is the contract that can score the most points since the points of each contract are added together.';
  }

  @override
  String rulesSaladDetailed(String contracts, String itemWithPoints) {
    return 'This contract is a combination of the contracts $contracts. Points are counted as follows:\n$itemWithPoints';
  }

  @override
  String rulesTrickRound(String player) {
    return '$player starts the first trick, and thereby determines the leading suit.\nThe player who played the highest card of that suit wins the trick and starts the next one.';
  }

  @override
  String get salad => 'Salad';

  @override
  String get saladScoresSubtitle => 'What is the score of each contract?';

  @override
  String get saveAndLeave => 'Save and leave';

  @override
  String get scores => 'Scores';

  @override
  String get scoresByContract => 'Scores by contract';

  @override
  String get scoresNotValid => 'Invalid scores';

  @override
  String seePreviousGame(String players) {
    return 'See the previous game with $players?';
  }

  @override
  String get settings => 'Settings';

  @override
  String get startGame => 'Start a game';

  @override
  String get table => 'The table';

  @override
  String get total => 'Total';

  @override
  String get trick => 'trick';

  @override
  String get unfold => 'Expand the choices';

  @override
  String get validate => 'Validate';

  @override
  String get validateScores => 'Validate scores';

  @override
  String whoWonItem(String item) {
    return 'Who won the $item?';
  }

  @override
  String get withdrawCard => 'Withdraw a card';

  @override
  String withdrawItem(String item) {
    return 'Withdraw one $item';
  }

  @override
  String withdrawNbCards(num nbCards) {
    String _temp0 = intl.Intl.pluralLogic(
      nbCards,
      locale: localeName,
      other: 'cards',
      one: 'card',
    );
    return 'Withdraw $nbCards $_temp0.';
  }

  @override
  String withdrawnCardsRules(int nbTricks) {
    return 'Each round, players receive $nbTricks cards each. Extra cards are set aside face up and then reshuffled at the end of the round.';
  }

  @override
  String get withdrawnCards => 'Withdrawn cards';

  @override
  String withdrawnCardsName(String item) {
    return 'Withdrawn ${item}s';
  }

  @override
  String get worstEnnemy => 'Worst ennemy';
}
