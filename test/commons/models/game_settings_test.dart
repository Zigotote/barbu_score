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
      (
        nbPlayers: 3,
        cardsToKeep: Map.fromIterable([14, 13, 12, 11, 10, 9], value: (_) => 4),
      ),
      (
        nbPlayers: 4,
        cardsToKeep: Map.fromIterable([
          14,
          13,
          12,
          11,
          10,
          9,
          8,
          7,
        ], value: (_) => 4),
      ),
      (
        nbPlayers: 5,
        cardsToKeep: Map.fromIterable([
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
        ], value: (_) => 4),
      ),
      (
        nbPlayers: 6,
        cardsToKeep: Map.fromIterable([
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
        ], value: (_) => 4),
      ),
      (
        nbPlayers: 7,
        cardsToKeep: Map.fromIterable([
          14,
          13,
          12,
          11,
          10,
          9,
          8,
        ], value: (_) => 8),
      ),
      (
        nbPlayers: 8,
        cardsToKeep: Map.fromIterable([
          14,
          13,
          12,
          11,
          10,
          9,
          8,
          7,
        ], value: (_) => 8),
      ),
      (
        nbPlayers: 9,
        cardsToKeep: Map.fromIterable([
          14,
          13,
          12,
          11,
          10,
          9,
          8,
          7,
          6,
        ], value: (_) => 8),
      ),
      (
        nbPlayers: 10,
        cardsToKeep: Map.fromIterable([
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
        ], value: (_) => 8),
      ),
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
      expect(GameSettings(nbTricksByPlayer: {5: 10}).getCardsToKeep(5), {
        14: 4,
        13: 4,
        12: 4,
        11: 4,
        10: 4,
        9: 4,
        8: 4,
        7: 4,
        6: 4,
        5: 4,
        4: 4,
        3: 4,
        2: 2,
      });
    });
    test("should keep Pierrick's cards for 10 players", () {
      expect(GameSettings(nbTricksByPlayer: {10: 10}).getCardsToKeep(10), {
        14: 8,
        13: 8,
        12: 8,
        11: 8,
        10: 8,
        9: 8,
        8: 8,
        7: 8,
        6: 8,
        5: 8,
        4: 8,
        3: 8,
        2: 4,
      });
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
