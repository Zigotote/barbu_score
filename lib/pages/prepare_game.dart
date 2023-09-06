import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';

import '../commons/models/player.dart';
import '../commons/notifiers/play_game.dart';
import '../commons/utils/screen.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/player_icon.dart';
import '../main.dart';

/// A page to be sure the players and the cards are ready to start
class PrepareGame extends ConsumerWidget {
  final double _circleDiameter = ScreenHelper.width * 0.5;
  final double _playerIconSize = ScreenHelper.width * 0.16;

  PrepareGame({super.key});

  double get _circleRadius => _circleDiameter / 2;

  /// Returns the values of the cards to take out for the party
  List<int> _getCardsToTakeOut(int nbPlayers) {
    return List.generate((52 - nbPlayers * 8) ~/ 4, (index) => 2 + index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> players = ref.read(playGameProvider).players;
    return DefaultPage(
      title: "Préparer la partie",
      hasLeading: true,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              const Text("Retirer toutes les cartes"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _getCardsToTakeOut(players.length).join(", "),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const Text("du paquet."),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: _circleDiameter + _playerIconSize * 2,
            child: _buildTable(context, players),
          ),
        ],
      ),
      bottomWidget: ElevatedButton(
        child: const Text("C'est parti !"),
        onPressed: () {
          Wakelock.enable();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushNamed(Routes.chooseContract);
        },
      ),
    );
  }

  Stack _buildTable(BuildContext context, List<Player> players) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: CircularText(
            children: [
              TextItem(
                text: Text(
                  "La table",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                space: 8,
                startAngle: 270,
                startAngleAlignment: StartAngleAlignment.center,
              )
            ],
            radius: _circleRadius + _playerIconSize,
          ),
        ),
        Positioned(
          top: _playerIconSize * 0.75,
          child: Container(
            width: _circleDiameter,
            height: _circleDiameter,
            margin: EdgeInsets.all(_playerIconSize / 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: _buildPlayers(context, players),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPlayers(BuildContext context, List<Player> players) {
    final theta = ((pi * 2) / (players.length * 2));
    return List.generate(
      players.length * 2,
      (index) {
        final angle = (theta * index);
        final topPosition = _circleRadius * -cos(angle) + _circleRadius;
        final leftPosition = _circleRadius * sin(angle) + _circleRadius;
        if (index % 2 == 0) {
          Player player = players[index ~/ 2];
          return Positioned(
            top: topPosition - _playerIconSize / 2,
            left: leftPosition - _playerIconSize,
            // specifies a width to be able to position the widget from its center (otherwise players with long names are not centered)
            width: _playerIconSize * 2,
            child: Column(
              children: [
                PlayerIcon(
                  image: player.image,
                  color: player.color,
                  size: _playerIconSize,
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    player.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Positioned(
            top: topPosition - _playerIconSize / 3.5,
            left: leftPosition - _playerIconSize / 3.5,
            width: _playerIconSize / 2,
            height: _playerIconSize / 2,
            child: Transform.rotate(
              angle: angle,
              child: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          );
        }
      },
    ).toList();
  }
}
