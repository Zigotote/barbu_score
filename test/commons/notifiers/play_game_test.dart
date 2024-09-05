import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';
import '../../utils.mocks.dart';

main() {
  group("#nextPlayer", () {
    for (var activeContracts in [
      ContractsInfo.values,
      [ContractsInfo.barbu, ContractsInfo.noLastTrick]
    ]) {
      test(
          "should change player if next player has never played any contract with $activeContracts",
          () {
        final mockStorage = MockMyStorage();
        mockActiveContracts(mockStorage, activeContracts);
        final game = createGame(4, []);

        final playGame = PlayGameNotifier(mockStorage);
        playGame.load(game);

        final result = playGame.nextPlayer();
        expect(result, isTrue);
        expect(game.currentPlayer, game.players[1]);
        expect(game.isFinished, isFalse);
      });
      test(
          "should change player if next player has played all contracts with $activeContracts",
          () {
        final mockStorage = MockMyStorage();
        mockActiveContracts(mockStorage, activeContracts);
        const expectedPlayerIndex = 2;
        final game = Game(
          players: List.generate(
            4,
            (index) => Player(
              name: defaultPlayerNames[index],
              color: PlayerColors.values[index],
              image: playerImages[index],
              contracts: index != expectedPlayerIndex
                  ? [
                      defaultBarbu,
                      defaultNoHearts,
                      defaultTrumps,
                      defaultDomino,
                      defaultNoQueens,
                      defaultNoTricks,
                      defaultNoLastTrick
                    ]
                  : [defaultDomino, defaultTrumps],
            ),
          ),
        );

        final playGame = PlayGameNotifier(mockStorage);
        playGame.load(game);

        playGame.nextPlayer();
        expect(game.currentPlayer, game.players[expectedPlayerIndex]);
        expect(game.isFinished, isFalse);
      });
    }
  });
}
