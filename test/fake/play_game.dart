import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/models/player.dart';
import 'package:barbu_score/commons/models/player_colors.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';
import 'package:barbu_score/commons/utils/player_icon_properties.dart';

import '../utils.dart';
import '../utils.mocks.dart';
import 'game.dart';

class FakePlayGame extends PlayGameNotifier {
  // TODO Océane to fix mockMyStorage2 ?
  FakePlayGame([Game? game]) : super(MockMyStorage2()) {
    this.game = game ??
        FakeGame(
          players: List.generate(
            nbPlayersByDefault,
            (index) => Player.create(
              name: defaultPlayerNames[index],
              color: PlayerColors.values[index],
              image: playerImages[index],
            ),
          ),
        );
  }
}
