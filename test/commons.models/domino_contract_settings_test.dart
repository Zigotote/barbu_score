import 'package:barbu_score/commons/models/contract_settings_models.dart';
import 'package:flutter_test/flutter_test.dart';

class _Tester {
  final int nbPlayers;
  final int pointsFirstPlayer;
  final int pointsLastPlayer;
  final List<int> expectedPoints;

  _Tester(
      {required this.nbPlayers,
      required this.pointsFirstPlayer,
      required this.pointsLastPlayer,
      required this.expectedPoints});
}

main() {
  group("#calculatePoints", () {
    for (var dominoTest in [
      // The values I play with
      _Tester(
        nbPlayers: 3,
        pointsFirstPlayer: -40,
        pointsLastPlayer: 40,
        expectedPoints: [-40, 0, 40],
      ),
      _Tester(
        nbPlayers: 4,
        pointsFirstPlayer: -40,
        pointsLastPlayer: 40,
        expectedPoints: [-40, -20, 20, 40],
      ),
      _Tester(
        nbPlayers: 5,
        pointsFirstPlayer: -40,
        pointsLastPlayer: 40,
        expectedPoints: [-40, -20, 0, 20, 40],
      ),
      _Tester(
        nbPlayers: 6,
        pointsFirstPlayer: -40,
        pointsLastPlayer: 40,
        expectedPoints: [-40, -20, -10, 10, 20, 40],
      ),
      // Some other values
      _Tester(
        nbPlayers: 6,
        pointsFirstPlayer: 0,
        pointsLastPlayer: 100,
        expectedPoints: [0, 20, 40, 60, 80, 100],
      ),
      _Tester(
        nbPlayers: 3,
        pointsFirstPlayer: 0,
        pointsLastPlayer: 1,
        expectedPoints: [0, 0, 1],
      ),
      _Tester(
        nbPlayers: 3,
        pointsFirstPlayer: 40,
        pointsLastPlayer: 40,
        expectedPoints: [40, 40, 40],
      ),
      _Tester(
        nbPlayers: 6,
        pointsFirstPlayer: 40,
        pointsLastPlayer: -40,
        expectedPoints: [40, 20, 10, -10, -20, -40],
      ),
      _Tester(
        nbPlayers: 3,
        pointsFirstPlayer: -40,
        pointsLastPlayer: 90,
        expectedPoints: [-40, 20, 90],
      ),
    ]) {
      test(
        "should calculate points for ${dominoTest.nbPlayers} players with min:${dominoTest.pointsFirstPlayer} and max:${dominoTest.pointsLastPlayer}",
        () => expect(
          DominoContractSettings(
            pointsFirstPlayer: dominoTest.pointsFirstPlayer,
            pointsLastPlayer: dominoTest.pointsLastPlayer,
          ).points[dominoTest.nbPlayers],
          dominoTest.expectedPoints,
        ),
      );
    }
  });
}
