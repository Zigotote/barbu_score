import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:flutter_test/flutter_test.dart';

const _defaultNbTricksByPlayer = {3: 8};

void main() {
  group("#copyWith", () {
    test("should change from fixedNbTricks to nbTricksByPlayer", () {
      final newGameSettings = GameSettings(
        fixedNbTricks: 8,
      ).copyWith(nbTricksByPlayer: _defaultNbTricksByPlayer);

      expect(newGameSettings.nbTricksByPlayer, _defaultNbTricksByPlayer);
      expect(newGameSettings.fixedNbTricks, isNull);
    });
    test("should change from nbTricksByPlayer to fixedNbTricks", () {
      final newGameSettings = GameSettings(
        nbTricksByPlayer: _defaultNbTricksByPlayer,
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
}
