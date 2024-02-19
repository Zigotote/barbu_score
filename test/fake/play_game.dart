import 'package:barbu_score/commons/models/game.dart';
import 'package:barbu_score/commons/notifiers/play_game.dart';

class FakePlayGame extends PlayGameNotifier {
  FakePlayGame(Game game) {
    this.game = game;
  }
}
