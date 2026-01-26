import 'package:barbu_score/commons/utils/constants.dart';
import 'package:collection/collection.dart';

/// A class to represent game settings
class GameSettings {
  /// Indicates if the best player is the one with the smallest or bigger score
  final bool goalIsMinScore;

  /// The number of tricks by round, if it's the same no matter how many players are playing. If null, [nbCardsInDeck] is required.
  final int? fixedNbTricks;

  /// The number of cards in the deck used to play. Equals to [kNbCardsInDeck] by default
  final int nbCardsInDeck;

  /// Indicates if random cards are withdrawn for each round. If not, the smallest ones are always taken out
  final bool withdrawRandomCards;

  GameSettings({
    this.goalIsMinScore = true,
    this.fixedNbTricks = kNbTricksByRound,
    this.nbCardsInDeck = kNbCardsInDeck,
    this.withdrawRandomCards = false,
  });

  GameSettings.fromJson(Map<String, dynamic> json)
    : goalIsMinScore = json["goalIsMinScore"],
      fixedNbTricks = json["fixedNbTricks"],
      nbCardsInDeck = json["nbCardsInDeck"],
      withdrawRandomCards = json["withdrawRandomCards"];

  Map<String, dynamic> toJson() {
    return {
      "goalIsMinScore": goalIsMinScore,
      "fixedNbTricks": fixedNbTricks,
      "nbCardsInDeck": nbCardsInDeck,
      "withdrawRandomCards": withdrawRandomCards,
    };
  }

  @override
  int get hashCode => Object.hash(
    goalIsMinScore,
    fixedNbTricks,
    nbCardsInDeck,
    withdrawRandomCards,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GameSettings &&
            goalIsMinScore == other.goalIsMinScore &&
            fixedNbTricks == other.fixedNbTricks &&
            nbCardsInDeck == other.nbCardsInDeck &&
            withdrawRandomCards == other.withdrawRandomCards;
  }

  GameSettings copyWith({
    bool? goalIsMinScore,
    bool deleteFixedNbTricks = false,
    int? fixedNbTricks,
    int? nbCardsInDeck,
    bool? withdrawRandomCards,
  }) {
    return GameSettings(
      goalIsMinScore: goalIsMinScore ?? this.goalIsMinScore,
      fixedNbTricks: deleteFixedNbTricks
          ? null
          : fixedNbTricks ?? this.fixedNbTricks,
      nbCardsInDeck: nbCardsInDeck ?? this.nbCardsInDeck,
      withdrawRandomCards: withdrawRandomCards ?? this.withdrawRandomCards,
    );
  }

  /// Returns the number of cards to use for a game with [nbPlayers]
  int getNbCards(int nbPlayers) => nbPlayers * getNbTricksByRound(nbPlayers);

  /// Returns the number of cards of each value in the final deck
  int getNbCardsOfEachValue(int nbPlayers) => 4 * getNbDecks(nbPlayers);

  /// Returns the number of tricks by round for a specific number of players
  int getNbTricksByRound(int nbPlayers) {
    if (fixedNbTricks != null) {
      return fixedNbTricks!;
    }
    final int nbTricksWithOneDeck = (nbCardsInDeck / nbPlayers).floor();
    // If there is 6 or more tricks, the game can be played with one deck
    if (nbTricksWithOneDeck >= 6) {
      return nbTricksWithOneDeck;
    }
    return (nbCardsInDeck * 2 / nbPlayers).floor();
  }

  /// Returns the values of the cards to keep for the game, link to the number of each card (from 1 to 8)
  Map<int, int> getCardsToKeep(int nbPlayers) {
    final cardIndexes = List.generate(
      13,
      (index) => index + 2,
    ).reversed.toList();
    final nbCardsOfEachValue = getNbCardsOfEachValue(nbPlayers);

    if (withdrawRandomCards) {
      return Map.fromIterable(cardIndexes, value: (_) => nbCardsOfEachValue);
    }

    final nbCardsInFinalDeck = getNbCards(nbPlayers);
    final cardsValues = cardIndexes.slice(
      0,
      (nbCardsInFinalDeck / nbCardsOfEachValue).ceil(),
    );
    return Map.fromIterable(
      cardsValues,
      value: (value) {
        if (value == cardsValues.last) {
          final nbRemainingCards = nbCardsInFinalDeck % nbCardsOfEachValue;
          return nbRemainingCards == 0 ? nbCardsOfEachValue : nbRemainingCards;
        }
        return nbCardsOfEachValue;
      },
    );
  }

  /// Returns the number of decks required for this number of cards
  int getNbDecks(int nbPlayers) {
    return (getNbCards(nbPlayers) / nbCardsInDeck).ceil();
  }
}
