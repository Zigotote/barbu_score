// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accept => 'Yes';

  @override
  String get activateContract => 'Activate contract';

  @override
  String addItem(String item) {
    return 'Add $item';
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
  String get appName => 'The Barbu';

  @override
  String get appTheme => 'App theme';

  @override
  String get appTitle => 'Barbu Score';

  @override
  String get availableColor => 'Available color';

  @override
  String get avatar => 'Avatar';

  @override
  String get barbu => 'Barbu';

  @override
  String get bestFriend => 'Best friend';

  @override
  String get cardsOrder =>
      'Aces are the highest cards. Before playing, the weakest cards must be removed until the required number is reached.';

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
  String get contractPoints => 'Contract points';

  @override
  String contractSettingsTitle(String contract) {
    return 'Settings\n$contract';
  }

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
  String get contractsToPlay => 'Contracts to play';

  @override
  String get createPlayers => 'Create players';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deactivatedForGame => 'Disabled for your games.';

  @override
  String get delete => 'Delete';

  @override
  String get deletePlayer => 'Delete player';

  @override
  String get domino => 'Domino';

  @override
  String get dominoScoreSubtitle => 'What is the order of the players?';

  @override
  String get endGame => 'End of game';

  @override
  String get english => 'English';

  @override
  String get errorAddPoints => 'Adding points impossible';

  @override
  String errorAddPointsDetails(String item, int nbItems) {
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
  String get errorNbItems =>
      'The number of items added does not match the expected number. Please try again.';

  @override
  String get fold => 'Collapse the choices';

  @override
  String get forGameAt => 'For a game of';

  @override
  String get french => 'French';

  @override
  String get fromTheDeck => 'from the deck.';

  @override
  String get gamePrinciple => 'Game principle';

  @override
  String get gamePrincipleDetails =>
      'This trick-taking game consists of 7 contracts that must be completed by all players. Each contract has specific rules that will be applied during the round of play.\nThe game ends when all players have completed all the contracts.';

  @override
  String get gameRound => 'Round of play';

  @override
  String get gameRoundRules =>
      'Distribute the cards among the players: each player must have 8 cards.*The first player chooses the contract he wishes to play and announces it to the other players.*He starts the trick by playing a card, which determines the suit of the trick.*Each player plays a card in clockwise order.*If a player does not have a card of the required suit, they can play any card from their hand. The value of this card will be considered as null.*At the end of the round, the player who played the highest-value card wins the trick. He will start the next trick.*The round ends when all players have played all their cards.*Points are then counted according to the contract chosen by the first player.*The player to the left of the previous first player starts the next round.';

  @override
  String get gameSaved => 'Game saved';

  @override
  String get go => 'Let\'s go!';

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
  String get invertScoreDetails =>
      'If a player wins all, their score becomes negative.';

  @override
  String get keep => 'Keep';

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
  String nbCardsRules(int nbCards, int nbPlayers) {
    return 'The game is played with $nbCards cards ($nbPlayers × 8).';
  }

  @override
  String nbItemsByPlayer(String item) {
    return 'Number of ${item}s per player';
  }

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
  String playerNameHint(int nb) {
    return 'Name of player $nb';
  }

  @override
  String playerTurn(String player) {
    return 'Turn of $player';
  }

  @override
  String get players => 'players';

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
  String get presentGame =>
      'Barbu is a game for 3 to 6 players, played with a deck of cards. The goal is to score as few points as possible.';

  @override
  String get previous => 'Previous';

  @override
  String get queen => 'queen';

  @override
  String get ranking => 'Ranking';

  @override
  String get refuseLoadGame => 'No, new game';

  @override
  String get refuseStartGame => 'No, resume game';

  @override
  String get rules => 'Game rules';

  @override
  String rulesBarbu(int points) {
    return 'The player who wins the king of hearts (Barbu) scores $points points.';
  }

  @override
  String get rulesDomino =>
      'Unlike other contracts, Domino is not a trick-taking contract.\nThe player choosing this contract determines the opening value of the Domino (for example, the Jack). If they have a card of that value, they place it on the table; otherwise, they pass their turn.\nThe next player can then place a card of the same suit and a value directly higher or lower (so the 10 or Queen of the previous suit). They can also place a card of the opening value, in another suit. If they cannot place a card, they indicate that they pass.\nThe game continues like this until all players have finished their hand. The objective is to play all of your cards as quickly as possible to score a minimum of points.';

  @override
  String rulesNoHearts(int points) {
    return 'Each player scores $points points per heart won.';
  }

  @override
  String rulesNoQueens(int points) {
    return 'Each player scores $points points per queen won.';
  }

  @override
  String rulesNoLastTrick(int points) {
    return 'The player who wins the last trick scores $points points.';
  }

  @override
  String rulesNoTricks(int points) {
    return 'Each player scores $points points per trick won.';
  }

  @override
  String rulesSalad(String contracts) {
    return 'This contract is a combination of the $contracts contracts.\nIt is the contract that can score the most points since the points of each contract are added together.';
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
  String get validateModify => 'Modify scores';

  @override
  String get validateScores => 'Validate scores';

  @override
  String whoWonItem(String item) {
    return 'Who won the $item?';
  }

  @override
  String get withdrawCards => 'Withdraw all cards';

  @override
  String withdrawCardsForPlayers(int nbPlayers, String cards) {
    return 'With $nbPlayers players, all the cards must therefore be removed: $cards.';
  }

  @override
  String withdrawItem(String item) {
    return 'Withdraw $item';
  }

  @override
  String get worstEnnemy => 'Worst ennemy';
}
