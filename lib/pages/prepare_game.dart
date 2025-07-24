import 'dart:math';

import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../commons/models/player.dart';
import '../commons/providers/play_game.dart';
import '../commons/utils/game_helpers.dart';
import '../commons/widgets/default_page.dart';
import '../commons/widgets/my_appbar.dart';
import '../commons/widgets/player_icon.dart';
import '../main.dart';

/// A page to be sure the players and the cards are ready to start
class PrepareGame extends ConsumerWidget {
  const PrepareGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> players = ref.read(playGameProvider).players;
    final screenHeight = MediaQuery.of(context).size.height;
    return DefaultPage(
      appBar: MyAppBar(Text(context.l10n.prepareGame), context: context),
      content: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight:
                screenHeight > 1000 ? screenHeight * 0.85 : screenHeight * 0.75,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 16,
            children: [
              _buildPrepareGameText(context, players),
              _buildTable(context, players),
            ],
          ),
        ),
      ),
      bottomWidget: ElevatedButton(
        child: Text(context.l10n.go),
        onPressed: () {
          WakelockPlus.enable();
          context.push(Routes.chooseContract);
        },
      ),
    );
  }

  Widget _buildPrepareGameText(BuildContext context, List<Player> players) {
    return MergeSemantics(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Text(context.l10n.withdrawCards),
          Text(
            getCardsToTakeOut(players.length).join(", "),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(context.l10n.fromTheDeck),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Player> players) {
    final multiplicator =
        MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0.5;
    return LayoutBuilder(builder: (context, constraints) {
      final circleDiameter = constraints.maxWidth * 0.6 * multiplicator;
      final circleRadius = circleDiameter / 2;
      final playerIconSize = constraints.maxWidth * 0.17 * multiplicator;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).textScaler.scale(16) * 3,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CircularText(
                children: [
                  TextItem(
                    text: Text(
                      context.l10n.table,
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
        ),
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
