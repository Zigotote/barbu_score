import 'package:barbu_score/commons/utils/game_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (var testData in [
    (nbPlayers: 3, cardsNumbersToTakeOut: [2, 3, 4, 5, 6, 7, 8]),
    (nbPlayers: 4, cardsNumbersToTakeOut: [2, 3, 4, 5, 6]),
    (nbPlayers: 5, cardsNumbersToTakeOut: [2, 3, 4]),
    (nbPlayers: 6, cardsNumbersToTakeOut: [2]),
  ]) {
    final nbPlayers = testData.nbPlayers;
    test(
        "should remove ${testData.cardsNumbersToTakeOut.length} cards for $nbPlayers",
        () {
      expect(getCardsToTakeOut(nbPlayers), testData.cardsNumbersToTakeOut);
    });
  }
}
