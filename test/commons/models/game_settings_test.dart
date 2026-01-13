import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("#copyWith", () {
    test("should change from fixedNbTricks to nbTricksByPlayer", () {
      final newGameSettings = GameSettings(
        fixedNbTricks: 8,
      ).copyWith(nbTricksByPlayer: kNbTricksByRoundByPlayer);

      expect(newGameSettings.nbTricksByPlayer, kNbTricksByRoundByPlayer);
      expect(newGameSettings.fixedNbTricks, isNull);
    });
    test("should change from nbTricksByPlayer to fixedNbTricks", () {
      final newGameSettings = GameSettings(
        nbTricksByPlayer: kNbTricksByRoundByPlayer,
      ).copyWith(fixedNbTricks: 8);

      expect(newGameSettings.nbTricksByPlayer, isNull);
      expect(newGameSettings.fixedNbTricks, 8);
    });
    test("should change other values", () {
      final newGameSettings = GameSettings(
        goalIsMinScore: true,
        withdrawRandomCards: true,
      ).copyWith(goalIsMinScore: false, withdrawRandomCards: false);

      expect(newGameSettings.goalIsMinScore, false);
      expect(newGameSettings.withdrawRandomCards, false);
    });
  });

  group("#getCardsToKeep", () {
    for (var testData in [
      (nbPlayers: 3, cardsToKeep: [14, 13, 12, 11, 10, 9]),
      (nbPlayers: 4, cardsToKeep: [14, 13, 12, 11, 10, 9, 8, 7]),
      (nbPlayers: 5, cardsToKeep: [14, 13, 12, 11, 10, 9, 8, 7, 6, 5]),
      (nbPlayers: 6, cardsToKeep: [14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3]),
      (nbPlayers: 7, cardsToKeep: [14, 13, 12, 11, 10, 9, 8]),
      (nbPlayers: 8, cardsToKeep: [14, 13, 12, 11, 10, 9, 8, 7]),
      (nbPlayers: 9, cardsToKeep: [14, 13, 12, 11, 10, 9, 8, 7, 6]),
      (nbPlayers: 10, cardsToKeep: [14, 13, 12, 11, 10, 9, 8, 7, 6, 5]),
    ]) {
      test(
        "should keep ${testData.cardsToKeep.length} cards for ${testData.nbPlayers} players",
        () {
          expect(
            GameSettings().getCardsToKeep(testData.nbPlayers),
            testData.cardsToKeep,
          );
        },
      );
    }
    test("should keep Pierrick's cards for 5 players", () {
      expect(GameSettings(nbTricksByPlayer: {5: 10}).getCardsToKeep(5), [
        14,
        13,
        12,
        11,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
      ]);
    });
  });

  group("#getNbDecks", () {
    for (var testData in [
      (nbPlayers: 3, nbDecks: 1),
      (nbPlayers: 4, nbDecks: 1),
      (nbPlayers: 5, nbDecks: 1),
      (nbPlayers: 6, nbDecks: 1),
      (nbPlayers: 7, nbDecks: 2),
      (nbPlayers: 8, nbDecks: 2),
      (nbPlayers: 9, nbDecks: 2),
      (nbPlayers: 10, nbDecks: 2),
    ]) {
      test(
        "should have ${testData.nbDecks} for ${testData.nbPlayers} cards",
        () {
          expect(
            GameSettings().getNbDecks(testData.nbPlayers),
            testData.nbDecks,
          );
        },
      );
    }
  });
}
