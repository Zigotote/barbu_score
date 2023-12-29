import 'package:barbu_score/commons/models/game.dart';

class FakeGame extends Game {
  final bool finished;

  FakeGame({super.players = const [], this.finished = false});

  @override
  bool get isFinished => finished;
}
