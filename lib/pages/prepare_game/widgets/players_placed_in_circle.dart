import 'dart:math';

import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../commons/models/player.dart';
import '../../../commons/providers/play_game.dart';
import '../../../commons/widgets/player_icon.dart';

class PlayersPlacedInCircle extends ConsumerWidget {
  final double circleDiameter;
  final double playerIconSize;

  const PlayersPlacedInCircle({
    super.key,
    required this.circleDiameter,
    required this.playerIconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> players = ref.read(playGameProvider).players;
    final circleRadius = circleDiameter / 2;
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularText(
          children: [
            TextItem(
              text: Text(
                context.l10n.table,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              space: 8,
              startAngle: 270,
              startAngleAlignment: StartAngleAlignment.center,
            ),
          ],
          radius: circleRadius + playerIconSize,
        ),
        Container(
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
              context,
              circleRadius,
              playerIconSize,
              players,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPlayers(
    BuildContext context,
    double circleRadius,
    double playerIconSize,
    List<Player> players,
  ) {
    final theta = ((pi * 2) / (players.length * 2));
    return List.generate(players.length * 2, (index) {
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
    }).toList();
  }
}
