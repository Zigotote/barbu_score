import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:flutter_test/flutter_test.dart';

class _Tester {
  final int nbPlayers;
  final DominoContractSettings settings;
  final List<int> expectedPoints;

  _Tester(
      {required this.nbPlayers,
      required this.settings,
      required this.expectedPoints});
}

main() {
  group("Test #calculatePoints for domino contract", () {
    for (var dominoTest in [
      // The values I play with
      _Tester(
        nbPlayers: 3,
        settings: DominoContractSettings(
            pointsFirstPlayer: -40, pointsLastPlayer: 40),
        expectedPoints: [-40, 0, 40],
      ),
      _Tester(
        nbPlayers: 4,
        settings: DominoContractSettings(
            pointsFirstPlayer: -40, pointsLastPlayer: 40),
        expectedPoints: [-40, -20, 20, 40],
      ),
      _Tester(
        nbPlayers: 5,
        settings: DominoContractSettings(
            pointsFirstPlayer: -40, pointsLastPlayer: 40),
        expectedPoints: [-40, -20, 0, 20, 40],
      ),
      _Tester(
        nbPlayers: 6,
        settings: DominoContractSettings(
            pointsFirstPlayer: -40, pointsLastPlayer: 40),
        expectedPoints: [-40, -20, -10, 10, 20, 40],
      ),
      // Some other values
      _Tester(
        nbPlayers: 6,
        settings:
            DominoContractSettings(pointsFirstPlayer: 0, pointsLastPlayer: 100),
        expectedPoints: [0, 20, 40, 60, 80, 100],
      ),
      _Tester(
        nbPlayers: 3,
        settings:
            DominoContractSettings(pointsFirstPlayer: 0, pointsLastPlayer: 1),
        expectedPoints: [0, 0, 1],
      ),
      _Tester(
        nbPlayers: 3,
        settings:
            DominoContractSettings(pointsFirstPlayer: 40, pointsLastPlayer: 40),
        expectedPoints: [40, 40, 40],
      ),
      _Tester(
        nbPlayers: 6,
        settings: DominoContractSettings(
            pointsFirstPlayer: 40, pointsLastPlayer: -40),
        expectedPoints: [40, 20, 10, -10, -20, -40],
      ),
      _Tester(
        nbPlayers: 3,
        settings: DominoContractSettings(
            pointsFirstPlayer: -40, pointsLastPlayer: 90),
        expectedPoints: [-40, 20, 90],
      ),
    ]) {
      test(
        "should calculate points for ${dominoTest.nbPlayers} players with min:${dominoTest.settings.pointsFirstPlayer} and max:${dominoTest.settings.pointsLastPlayer}",
        () => expect(
          dominoTest.settings.calculatePoints(dominoTest.nbPlayers),
          dominoTest.expectedPoints,
        ),
      );
    }
  });
}
