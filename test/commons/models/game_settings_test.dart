import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("#copyWith", () {
    test("should set fixedNbTricks to true", () {
      final newGameSettings = GameSettings(
        fixedNbTricks: false,
        nbCardsInDeck: 32,
      ).copyWith(fixedNbTricks: true);

      expect(newGameSettings.fixedNbTricks, true);
      expect(newGameSettings.nbCardsInDeck, kNbCardsInDeck);
    });
    test("should change other values", () {
      final newGameSettings = GameSettings(
        goalIsMinScore: true,
        withdrawRandomCards: true,
      ).copyWith(goalIsMinScore: false, withdrawRandomCards: false);

      expect(newGameSettings.fixedNbTricks, true);
      expect(newGameSettings.nbCardsInDeck, kNbCardsInDeck);
      expect(newGameSettings.goalIsMinScore, false);
      expect(newGameSettings.withdrawRandomCards, false);
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
        "should have ${testData.nbDecks} deck for ${testData.nbPlayers} players and fixedNbTricks",
        () {
          expect(
            GameSettings().getNbDecks(testData.nbPlayers),
            testData.nbDecks,
          );
        },
      );
    }

    for (var testData in [
      (nbPlayers: 3, nbDecks: 1),
      (nbPlayers: 4, nbDecks: 1),
      (nbPlayers: 5, nbDecks: 1),
      (nbPlayers: 6, nbDecks: 1),
      (nbPlayers: 7, nbDecks: 1),
      (nbPlayers: 8, nbDecks: 1),
      (nbPlayers: 9, nbDecks: 2),
      (nbPlayers: 10, nbDecks: 2),
    ]) {
      test(
        "should have ${testData.nbDecks} deck for ${testData.nbPlayers} players and optimized nb tricks",
        () {
          expect(
            GameSettings(fixedNbTricks: false).getNbDecks(testData.nbPlayers),
            testData.nbDecks,
          );
        },
      );
    }
  });

  group("#getNbTricksByRound", () {
    for (var testData in [
      (nbPlayers: 3, nbTricks: 17),
      (nbPlayers: 4, nbTricks: 13),
      (nbPlayers: 5, nbTricks: 10),
      (nbPlayers: 6, nbTricks: 8),
      (nbPlayers: 7, nbTricks: 7),
      (nbPlayers: 8, nbTricks: 6),
      (nbPlayers: 9, nbTricks: 11),
      (nbPlayers: 10, nbTricks: 10),
    ]) {
      test(
        "should have ${testData.nbTricks} tricks for ${testData.nbPlayers} players with 52 cards",
        () {
          expect(
            GameSettings(
              fixedNbTricks: false,
            ).getNbTricksByRound(testData.nbPlayers),
            testData.nbTricks,
          );
        },
      );
    }
    for (var testData in [
      (nbPlayers: 3, nbTricks: 10),
      (nbPlayers: 4, nbTricks: 8),
      (nbPlayers: 5, nbTricks: 6),
      (nbPlayers: 6, nbTricks: 10),
      (nbPlayers: 7, nbTricks: 9),
      (nbPlayers: 8, nbTricks: 8),
      (nbPlayers: 9, nbTricks: 7),
      (nbPlayers: 10, nbTricks: 6),
    ]) {
      test(
        "should have ${testData.nbTricks} tricks for ${testData.nbPlayers} players with 32 cards",
        () {
          expect(
            GameSettings(
              fixedNbTricks: false,
              nbCardsInDeck: 32,
            ).getNbTricksByRound(testData.nbPlayers),
            testData.nbTricks,
          );
        },
      );
    }
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
        "should keep ${testData.cardsToKeep.length} cards for ${testData.nbPlayers} players with fixedNbTricks",
        () {
          expect(
            GameSettings().getCardsToKeep(testData.nbPlayers),
            testData.cardsToKeep,
          );
        },
      );
    }
    for (var testData in [
      (
        nbPlayers: 3,
        cardsToKeep: {
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
          2: 3,
        },
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
          6,
          5,
          4,
          3,
          2,
        ], value: (_) => 4),
      ),
      (
        nbPlayers: 5,
        cardsToKeep: {
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
        },
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
        cardsToKeep: {
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
          2: 1,
        },
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
          6,
          5,
          4,
          3,
        ], value: (_) => 4),
      ),
      (
        nbPlayers: 9,
        cardsToKeep: {
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
          2: 3,
        },
      ),
      (
        nbPlayers: 10,
        cardsToKeep: {
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
        },
      ),
    ]) {
      test("should keep optimized cards for ${testData.nbPlayers} players", () {
        expect(
          GameSettings(fixedNbTricks: false).getCardsToKeep(testData.nbPlayers),
          testData.cardsToKeep,
        );
      });
    }
    test("should keep all cards if withdrawRandomCard", () {
      expect(
        GameSettings(withdrawRandomCards: true).getCardsToKeep(3),
        Map.fromIterable([
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
        ], value: (_) => 4),
      );
    });
  });
}
