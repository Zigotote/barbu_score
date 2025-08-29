import 'package:barbu_score/commons/utils/game_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
        expect(getCardsToKeep(testData.nbPlayers), testData.cardsToKeep);
      });
    }
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
      test("should have ${testData.nbDecks} for ${testData.nbPlayers} players",
          () {
        expect(getNbDecks(testData.nbPlayers), testData.nbDecks);
      });
    }
  });
}
