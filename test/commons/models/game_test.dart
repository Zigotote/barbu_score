import 'package:barbu_score/commons/models/contract_info.dart';
import 'package:barbu_score/commons/models/contract_models.dart';
import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

main() {
  group("#nextPlayer", () {
    final players = List.generate(
      4,
      (index) => Player(
        name: defaultPlayerNames[index],
        color: PlayerColors.values[index],
        image: playerImages[index],
        contracts: [],
      ),
    );
    test("should change player when has next", () {
      final game = Game(players: players);

      game.nextPlayer();

      expect(game.currentPlayer, players[1]);
    });
    test("should go to first player when has not next", () {
      final game = Game(players: players)
        ..currentPlayerIndex = players.length - 1;

      game.nextPlayer();

      expect(game.currentPlayer, players[0]);
    });
  });
  group("#getPlayersWithPlayedContract", () {
    for (int nbPlayersWithContract = 0;
        nbPlayersWithContract < 4;
        nbPlayersWithContract++) {
      test("should return $nbPlayersWithContract players with contract", () {
        final game = Game(
          players: List.generate(
            4,
            (index) => Player(
              name: defaultPlayerNames[index],
              color: PlayerColors.values[index],
              image: playerImages[index],
              contracts: [
                defaultBarbu,
                if (index < nbPlayersWithContract) defaultNoHearts
              ],
            ),
          ),
        );

        final playersWithContract =
            game.getPlayersWithPlayedContract(ContractsInfo.noHearts);

        expect(playersWithContract.length, nbPlayersWithContract);
        for (var (index, player) in game.players.indexed) {
          expect(playersWithContract.contains(player.name),
              index < nbPlayersWithContract);
        }
      });
    }
  });
}
