import 'dart:math';

import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../commons/models/player.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/utils/game_helpers.dart';
import '../../commons/widgets/default_page.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../main.dart';
import 'widgets/players_placed_in_circle.dart';
import 'widgets/players_placed_in_grid.dart';

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
        child: ConstrainedBox(
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
    final cardsToKeep = getCardsToKeep(players.length);
    return MergeSemantics(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Text(context.l10n.cardsToKeep),
          Text(
            context.l10n.cardInterval(
              context.l10n.cardName(cardsToKeep[cardsToKeep.length - 1]),
              context.l10n.cardName(cardsToKeep[0]),
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(context.l10n.fromTheDeck(getNbDecks(players.length))),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Player> players) {
    final multiplicator =
        MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0.5;
    return LayoutBuilder(builder: (context, constraints) {
      final widthConstraint = constraints.maxWidth;
      final playerIconSize = widthConstraint * 0.17 * multiplicator;
      final circleDiameter = widthConstraint * 0.6 * multiplicator;
      final circleRadius = circleDiameter / 2;
      final circlePerimeter = 2 * pi * circleRadius;
      double spaceBetweenPlayers = 1.5;
      if (widthConstraint <= 768) {
        spaceBetweenPlayers = 1.25;
      }
      if (widthConstraint <= 576) {
        spaceBetweenPlayers = 1.75;
      }
      final placeForPlayersInCircle = playerIconSize *
          players.length *
          MediaQuery.of(context).textScaler.scale(spaceBetweenPlayers);

      if (placeForPlayersInCircle >= circlePerimeter) {
        return PlayersPlacedInGrid();
      }
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).textScaler.scale(12) * 3,
        ),
        child: PlayersPlacedInCircle(
          circleDiameter: circleDiameter,
          playerIconSize: playerIconSize,
        ),
      );
    });
  }
}
