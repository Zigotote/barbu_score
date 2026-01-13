import 'dart:convert';

import 'package:barbu_score/commons/utils/constants.dart';
import 'package:collection/collection.dart';

/// A class to represent game settings
class GameSettings {
  /// Indicates if the best player is the one with the smallest or bigger score
  final bool goalIsMinScore;

  /// The number of tricks by round, if it's the same no matter how many players are playing. If not this value is null and [nbTricksByPlayer] is required.
  final int? fixedNbTricks;

  /// The number of tricks by round, depending on the number of players in the game. If null, [fixedNbTricks] is required
  Map<int, int>? nbTricksByPlayer;

  /// Indicates if random cards are withdrawn for each round. If not, the smallest ones are always taken out
  final bool withdrawRandomCards;

  GameSettings({
    this.goalIsMinScore = true,
    int? fixedNbTricks,
    Map<int, int>? nbTricksByPlayer,
    this.withdrawRandomCards = false,
  }) : fixedNbTricks = nbTricksByPlayer == null
           ? (fixedNbTricks ?? kNbTricksByRound)
           : null,
       nbTricksByPlayer = fixedNbTricks == null ? nbTricksByPlayer : null;

  GameSettings.fromJson(Map<String, dynamic> json)
    : goalIsMinScore = json["goalIsMinScore"],
      fixedNbTricks = json["fixedNbTricks"],
      nbTricksByPlayer = json["nbTricksByPlayer"] != null
          ? Map.castFrom({
              for (var entry in jsonDecode(json["nbTricksByPlayer"]).entries)
                int.parse(entry.key): int.parse(entry.value),
            })
          : null,
      withdrawRandomCards = json["withdrawRandomCards"];

  Map<String, dynamic> toJson() {
    return {
      "goalIsMinScore": goalIsMinScore,
      "fixedNbTricks": fixedNbTricks,
      "nbTricksByPlayer": nbTricksByPlayer != null
          ? jsonEncode({
              for (var entry in nbTricksByPlayer!.entries)
                '${entry.key}': '${entry.value}',
            })
          : null,
      "withdrawRandomCards": withdrawRandomCards,
    };
  }

  @override
  int get hashCode => Object.hash(
    goalIsMinScore,
    fixedNbTricks,
    nbTricksByPlayer,
    withdrawRandomCards,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GameSettings &&
            goalIsMinScore == other.goalIsMinScore &&
            fixedNbTricks == other.fixedNbTricks &&
            (nbTricksByPlayer?.entries.every(
                  (entry) => entry.value == other.nbTricksByPlayer?[entry.key],
                ) ??
                true) &&
            withdrawRandomCards == other.withdrawRandomCards;
  }

  GameSettings copyWith({
    bool? goalIsMinScore,
    int? fixedNbTricks,
    Map<int, int>? nbTricksByPlayer,
    bool? withdrawRandomCards,
  }) {
    return GameSettings(
      goalIsMinScore: goalIsMinScore ?? this.goalIsMinScore,
      fixedNbTricks: nbTricksByPlayer != null
          ? null
          : fixedNbTricks ?? this.fixedNbTricks,
      nbTricksByPlayer: fixedNbTricks != null
          ? null
          : nbTricksByPlayer ?? this.nbTricksByPlayer,
      withdrawRandomCards: withdrawRandomCards ?? this.withdrawRandomCards,
    );
  }

  /// Returns the number of tricks by round for a specific number of players. If nothing saved, returns [kNbTricksByRound]
  int getNbTricksByRound(int nbPlayers) =>
      fixedNbTricks ?? nbTricksByPlayer?[nbPlayers] ?? kNbTricksByRound;

  /// Returns the number of cards to use for a game with [nbPlayers]
  int getNbCards(int nbPlayers) => nbPlayers * getNbTricksByRound(nbPlayers);

  /// Returns the values of the cards to keep for the game
  List<int> getCardsToKeep(int nbPlayers) {
    final cardIndexes = List.generate(
      13,
      (index) => index + 2,
    ).reversed.toList();

    return cardIndexes.slice(
      0,
      (getNbCards(nbPlayers) / (4 * getNbDecks(nbPlayers))).toInt(),
    );
  }

  /// Returns the number of decks required for this number of cards
  int getNbDecks(int nbPlayers) {
    return (getNbCards(nbPlayers) / 52).ceil();
  }
}
