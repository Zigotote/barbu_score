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
  String get aboutLea => 'Léa LOUESDON, creator of the graphic design elements';

  @override
  String get aboutOceane =>
      'Océane GILLARD, in charge of the app\'s development';

  @override
  String get aboutTheApp =>
      'The Score Barbu app is developed by passionate people who care about meeting Barbu players\' needs as well as possible!';

  @override
  String get aboutTheTeam => 'The team is made up of: ';

  @override
  String get accept => 'Yes';

  @override
  String get ace => 'ace';

  @override
  String get activateContract => 'Activate the contract';

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
      'The salad must have at least one contract to play in order to be activated.';

  @override
  String get alertContractPlayed => 'The contract has already been played';

  @override
  String alertContractPlayedBy(String players) {
    return 'The contract has already been played by $players. Any changes in the settings of this contract will affect the current game.';
  }

  @override
  String get alertExistingGame => 'A saved game exists';

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
      'Did you spot a problem or have a suggestion for improvement? You can let us know by email:';

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
  String get cardsOrder => 'Aces are the highest cards.';

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
      other: 'from $nbDecks decks',
      one: 'from a deck',
    );
    return 'Before playing, you need to keep the highest cards $_temp0 of $nbCardsInDeck cards until you reach the required number. For $nbPlayers, you therefore only need to keep the following cards: $cards';
  }

  @override
  String cardToKeepPartially(String nbCards, String card) {
    String _temp0 = intl.Intl.selectLogic(nbCards, {
      '1': '♥',
      '2': '♥♦',
      '3': '♥♦♣',
      '4': '♥♦',
      '5': '♥♦ and a ♣',
      '6': '♥♦♣',
      '7': '♥♦♣ and a ♠',
      'other': '',
    });
    return '$card$_temp0';
  }

  @override
  String get changesSaved => 'Changes saved';

  @override
  String get changesSavedDetails =>
      'The changes have been saved and are now in effect.';

  @override
  String get close => 'Close';

  @override
  String get color => 'Color';

  @override
  String confirmStartGame(String players) {
    return 'Confirm the creation of a new game? If so, the previous game with $players will be lost.';
  }

  @override
  String get contact => 'Contact';

  @override
  String get contactByMail => 'Contact by email';

  @override
  String get contactReason => 'What would you like to report?';

  @override
  String get contracts => 'Contracts';

  @override
  String contractsOf(String player) {
    return '$player\'s contracts';
  }

  @override
  String get contractsRules =>
      'The game of Barbu includes the following contracts:';

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
  String get deactivatedForGame => 'Deactivated for your games.';

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
  String get discardCard => 'Remove a card';

  @override
  String discardItem(String item) {
    return 'Remove one $item';
  }

  @override
  String discardNbCards(num nbCards) {
    String _temp0 = intl.Intl.pluralLogic(
      nbCards,
      locale: localeName,
      other: 'cards',
      one: 'card',
    );
    return 'Discard $nbCards $_temp0.';
  }

  @override
  String discardedCardsRules(int nbTricks) {
    return 'Each round, everyone is dealt $nbTricks cards. The extra cards are set aside face up, then reshuffled at the end of the round.';
  }

  @override
  String get discardedCards => 'Removed cards';

  @override
  String discardedCardsName(String item) {
    return 'Removed ${item}s';
  }

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
  String get errorAddItem => 'Cannot add item';

  @override
  String errorAddItemDetails(String item, int nbItems) {
    return 'The number of $item exceeds the number of items that can be won, set at $nbItems.';
  }

  @override
  String get errorDomino => 'Not all players have been ranked.';

  @override
  String get errorLaunchGame => 'Cannot start a game';

  @override
  String get errorLaunchGameDetails =>
      'All contracts are disabled in the settings. At least one contract must be enabled to play.';

  @override
  String get errorAddDiscardedCard => 'Cannot add discarded card';

  @override
  String errorAddDiscardedCardDetails(String item, int nbItems) {
    return 'The number of $item exceeds the number of cards in the discard pile, set at $nbItems.';
  }

  @override
  String get feature => 'A suggestion';

  @override
  String get fold => 'Collapse choices';

  @override
  String get forGameAt => 'For a game with';

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
  String get game => 'Partie';

  @override
  String get gamePrinciple => 'Game principle';

  @override
  String get gamePrincipleDetails =>
      'This trick-taking game is made up of different contracts that must be completed by all players. Each contract has its own specific rules, which apply during that round.\nThe game ends when everyone has completed all the contracts.';

  @override
  String get gameRound => 'Round';

  @override
  String get gameRoundRules =>
      'Deal the same number of cards to everyone.*The First Player chooses which contract to play and announces it to the others.*They lead the trick by playing a card, which sets the trick\'s suit.*Each person plays a card clockwise.*If a person doesn\'t have a card of the suit asked for, they may play any card from their hand. That card\'s value is then considered null.*At the end of the round, the person who played the highest card wins the trick. They lead the next trick.*The round ends once all the cards have been played.*Points are then counted according to the contract chosen by the First Player.*The person sitting to their left starts the next round.';

  @override
  String get gameSaved => 'Game saved';

  @override
  String get go => 'Let\'s go!';

  @override
  String get goal => 'Goal';

  @override
  String get goHome => 'Back to home';

  @override
  String get heart => 'heart';

  @override
  String get hintDarkMode => 'dark mode';

  @override
  String get hintLightMode => 'light mode';

  @override
  String get hintForDarkMode => 'switch to dark mode';

  @override
  String get hintForLightMode => 'switch to light mode';

  @override
  String get invertScore => 'Score inversion';

  @override
  String get invertScoreDetails =>
      'If a player wins everything, their score is inverted.';

  @override
  String get invertScoreNegativeDetails =>
      'If a player wins everything, their score becomes negative.';

  @override
  String get invertScorePositiveDetails =>
      'If a player wins everything, their score becomes positive.';

  @override
  String get jack => 'jack';

  @override
  String get keep => 'Keep';

  @override
  String get king => 'king';

  @override
  String get language => 'Language';

  @override
  String get lastTrick => 'Last trick';

  @override
  String get loadGame => 'Load a game';

  @override
  String get loadGameIndication => 'Select \"Load a game\" to continue it.';

  @override
  String loadPreviousGame(String players) {
    return 'Resume the previous game with $players?';
  }

  @override
  String get lowest => 'Lowest';

  @override
  String get maxScore => 'High score';

  @override
  String get minScore => 'Low score';

  @override
  String get mix => 'Shuffle';

  @override
  String modify(String contract) {
    return 'Edit $contract';
  }

  @override
  String get modifyContractsSettings =>
      'Contracts can be edited on the settings page, to customize their points and variations.';

  @override
  String get modifyPlayer => 'Edit player';

  @override
  String get modifySettings => 'Edit settings';

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
      'An optimized number of tricks means dealing all the cards in the deck out evenly.';

  @override
  String get nbTricksQuestion => 'Number of tricks';

  @override
  String get next => 'Next';

  @override
  String get noGameFound => 'No game found';

  @override
  String get noGameFoundDetails =>
      'The previous game could not be found. Starting a new game.';

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
  String get player => 'player';

  @override
  String playerNameHint(int nb) {
    return 'Name P$nb';
  }

  @override
  String get playerTurn => 'Turn of';

  @override
  String get playersOrder => 'Player order';

  @override
  String get points => 'points';

  @override
  String pointsBy(String item) {
    return 'Points per $item';
  }

  @override
  String pointsOf(String item) {
    return '$item\'s points';
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
  String get rateApp => 'Rate the app';

  @override
  String get refuseLoadGame => 'No, new game';

  @override
  String get refuseStartGame => 'No, resume the game';

  @override
  String get reportBug => 'Report a bug';

  @override
  String get reportBugMail =>
      'Hello,\n\nI would like to report a bug I encountered in the app. Here are the details:\n\n- Bug description (explain what happened, what you were doing before the problem occurred, etc.):\n\n- Steps to reproduce the bug (list the actions needed to make the problem happen again):\n\n- Expected behavior (what should have happened):';

  @override
  String get requestFeature => 'Suggest a feature';

  @override
  String get requestFeatureMail =>
      'Hello,\n\nI would like to suggest a new feature for the app, in order to...';

  @override
  String get rules => 'Game rules';

  @override
  String rulesBarbu(int points) {
    return 'The player who wins the king of hearts (Barbu) scores $points points.';
  }

  @override
  String rulesBarbuInSalad(int points) {
    return '- the king of hearts (Barbu) is worth $points points';
  }

  @override
  String get rulesDomino =>
      'Unlike the other contracts, Domino is not a trick-taking contract. The goal of this contract is to place all the cards in the deck on the table, sorted by suit and in ascending order.\nThe player who chose this contract determines the opening value for the sequence (for example, the jack). If they have a card of that value, they place it on the table; otherwise, they pass.\nThe next player can then place a card of the same suit with a value directly above or below (so the 10 or the queen of the previous suit), or a card of the opening value in another suit. If they play an ace, they can play again. If they can\'t place a card, they pass.\nThe game continues until everyone has emptied their hand. The goal is to place all your cards as quickly as possible.';

  @override
  String rulesDominoDetailed(String player, String points) {
    return 'Unlike the other contracts, Domino is not a trick-taking contract. The goal of this contract is to place all the cards in the deck on the table, sorted by suit and in ascending order.\n$player determines the opening value for the sequence (for example, the jack), and places a card of that value if they have one in hand.\nThe next player then places a card of the same suit with a value directly above or below (so the 10 or the queen of the previous suit), or a card of the opening value. If they play an ace, they can play again. If they can\'t place a card, they pass.\nThe game continues until everyone has emptied their hand.';
  }

  @override
  String rulesNoHearts(int points) {
    return 'Each player scores $points points per heart won.';
  }

  @override
  String rulesNoHeartsInSalad(int points) {
    return '- each heart is worth $points points';
  }

  @override
  String rulesNoQueens(int points) {
    return 'Each player scores $points points per queen won.';
  }

  @override
  String rulesNoQueensInSalad(int points) {
    return '- each queen is worth $points points';
  }

  @override
  String rulesNoLastTrick(int points) {
    return 'The player who wins the last trick scores $points points.';
  }

  @override
  String rulesNoLastTrickInSalad(int points) {
    return '- the last trick is worth $points points';
  }

  @override
  String rulesNoTricks(int points) {
    return 'Each player scores $points points per trick won.';
  }

  @override
  String rulesNoTricksInSalad(int points) {
    return '- each trick is worth $points points';
  }

  @override
  String rulesSalad(String contracts) {
    return 'This contract is a combination of the $contracts contracts.\nIt\'s the contract that can score the most points, since the points from each contract are added together.';
  }

  @override
  String rulesSaladDetailed(String contracts, String itemWithPoints) {
    return 'This contract is a combination of the $contracts contracts. Points are counted as follows:\n$itemWithPoints';
  }

  @override
  String rulesTrickRound(String player) {
    return '$player leads the first trick, which sets its suit.\nThe player who played the highest card of that suit wins the trick. They lead the next trick.';
  }

  @override
  String rulesTrumps(int points) {
    return 'The First Player chooses a suit, which becomes trumps. It beats all the others. If a player doesn\'t have a card of the suit led, they must play a trump if they have one. If further trumps are played during the trick, they must be higher in value than the previous ones.\nEach player scores $points points per trick won.';
  }

  @override
  String rulesTrumpsDetailed(String player, int points) {
    return '$player chooses a suit, which becomes trumps. It beats all the others.\n$player leads the first trick, which sets its suit. If a player doesn\'t have a card of the suit led, they must play a trump if they have one. If further trumps are played during the trick, they must be higher in value than the previous ones.\nThe player who played the highest trump, or otherwise the highest card of the suit asked for, wins the trick. They lead the next trick.\n\nEach player scores $points points per trick won.';
  }

  @override
  String get salad => 'Salad';

  @override
  String get saladScoresSubtitle => 'What\'s the score for each contract?';

  @override
  String get saveAndLeave => 'Save and exit';

  @override
  String get scores => 'Scores';

  @override
  String get scoresByContract => 'Scores by contract';

  @override
  String get scoresNotValid => 'Invalid scores';

  @override
  String seePreviousGame(String players) {
    return 'Review the previous game with $players?';
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
  String get trumps => 'Trumps';

  @override
  String get unfold => 'Expand choices';

  @override
  String get validate => 'Validate';

  @override
  String get validateScores => 'Validate scores';

  @override
  String whoWonItem(String item) {
    return 'Who won the $item?';
  }

  @override
  String get worstEnnemy => 'Worst opponent';
}
