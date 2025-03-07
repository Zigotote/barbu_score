import 'package:barbu_score/commons/utils/contract_scores.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/utils.dart';

main() {
  test("should return null if no scores", () {
    expect(sumScores([]), isNull);
  });

  test("should sum scores and be idempotent", () {
    final List<Map<String, int>?> scores = [
      {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index == 0 ? 50 : 0
      },
      {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index % 2 == 1 ? 20 : 0
      },
      {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index == defaultPlayerNames.length - 1 ? -40 : 0
      }
    ];
    expect(sumScores(scores), {
      defaultPlayerNames[0]: 50,
      defaultPlayerNames[1]: 20,
      defaultPlayerNames[2]: 0,
      defaultPlayerNames[3]: 20,
      defaultPlayerNames[4]: 0,
      defaultPlayerNames[5]: -20,
    });
    expect(scores, [
      {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index == 0 ? 50 : 0
      },
      {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index % 2 == 1 ? 20 : 0
      },
      {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index == defaultPlayerNames.length - 1 ? -40 : 0
      }
    ]);
  });
  for (var isInFirst in [true, false]) {
    test(
        "should sum scores with null map in ${isInFirst ? "first" : "last"} position",
        () {
      final expectedScores = {
        for (var (index, player) in defaultPlayerNames.indexed)
          player: index == 0 ? 50 : 0
      };
      final scores =
          isInFirst ? [null, expectedScores] : [expectedScores, null];
      expect(sumScores(scores), expectedScores);
    });
  }
}
