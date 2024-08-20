import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../commons/models/player.dart';
import '../commons/notifiers/play_game.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/player_icon.dart';
import '../main.dart';

/// A page to be sure the players and the cards are ready to start
class PrepareGame extends ConsumerWidget {
  const PrepareGame({super.key});

  /// Returns the values of the cards to take out for the party
  @visibleForTesting
  static List<int> getCardsToTakeOut(int nbPlayers) {
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
                  getCardsToTakeOut(players.length).join(", "),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const Text("du paquet."),
            ],
          ),
          _buildTable(context, players),
        ],
      ),
      bottomWidget: ElevatedButton(
        child: const Text("C'est parti !"),
        onPressed: () {
          WakelockPlus.enable();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushNamed(Routes.chooseContract);
        },
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Player> players) {
    return LayoutBuilder(builder: (context, constraints) {
      final circleDiameter = constraints.maxWidth * 0.6;
      final circleRadius = circleDiameter / 2;
      final playerIconSize = constraints.maxWidth * 0.17;
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
              radius: circleRadius + playerIconSize,
            ),
          ),
          Positioned(
            top: playerIconSize * 0.75,
            child: Container(
              width: circleDiameter,
              height: circleDiameter,
              margin: EdgeInsets.all(playerIconSize / 2),
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
                children: _buildPlayers(
                    context, circleRadius, playerIconSize, players),
              ),
            ),
          ),
        ],
      );
    });
  }

  List<Widget> _buildPlayers(BuildContext context, double circleRadius,
      double playerIconSize, List<Player> players) {
    final theta = ((pi * 2) / (players.length * 2));
    return List.generate(
      players.length * 2,
      (index) {
        final angle = (theta * index);
        final topPosition = circleRadius * -cos(angle) + circleRadius;
        final leftPosition = circleRadius * sin(angle) + circleRadius;
        if (index % 2 == 0) {
          Player player = players[index ~/ 2];
          return Positioned(
            top: topPosition - playerIconSize / 2,
            left: leftPosition - playerIconSize,
            // specifies a width to be able to position the widget from its center (otherwise players with long names are not centered)
            width: playerIconSize * 2,
            child: Column(
              children: [
                PlayerIcon(
                  image: player.image,
                  color: player.color,
                  size: playerIconSize,
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
            top: topPosition - playerIconSize / 3.5,
            left: leftPosition - playerIconSize / 3.5,
            width: playerIconSize / 2,
            height: playerIconSize / 2,
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
