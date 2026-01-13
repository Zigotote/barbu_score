import 'dart:math';

import 'package:barbu_score/commons/models/game_settings.dart';
import 'package:barbu_score/commons/providers/storage.dart';
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../commons/models/player.dart';
import '../../commons/providers/play_game.dart';
import '../../commons/widgets/custom_buttons.dart';
import '../../commons/widgets/my_appbar.dart';
import '../../commons/widgets/my_default_page.dart';
import '../../main.dart';
import 'widgets/players_placed_in_circle.dart';
import 'widgets/players_placed_in_grid.dart';

/// A page to be sure the players and the cards are ready to start
class PrepareGame extends ConsumerWidget {
  const PrepareGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Player> players = ref.read(playGameProvider).players;
    final gameSettings = ref.read(storageProvider).getGameSettings();
    return Scaffold(
      appBar: MyAppBar(Text(context.l10n.prepareGame), context: context),
      body: SafeArea(
        child: CustomScrollView(
          physics: MyDefaultPage.physics,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: MyDefaultPage.appPadding,
                child: _buildPrepareGameText(context, gameSettings, players),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: MyDefaultPage.appPadding,
                      child: _buildTable(context, players),
                    ),
                  ),
                  Padding(
                    padding: MyDefaultPage.appPadding,
                    child: ElevatedButtonFullWidth(
                      child: Text(context.l10n.go),
                      onPressed: () {
                        WakelockPlus.enable();
                        context.push(Routes.chooseContract);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrepareGameText(
    BuildContext context,
    GameSettings gameSettings,
    List<Player> players,
  ) {
    final cardsToKeep = gameSettings.getCardsToKeep(players.length);
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
          Text(
            context.l10n.fromTheDeck(gameSettings.getNbDecks(players.length)),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Player> players) {
    final minSizeConstraint = MediaQuery.sizeOf(context).width;
    final multiplicator =
        MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0.5;

    final playerIconSize = minSizeConstraint * 0.17 * multiplicator;
    final circleDiameter = minSizeConstraint * 0.6 * multiplicator;
    final circleRadius = circleDiameter / 2;
    final circlePerimeter = 2 * pi * circleRadius;
    double spaceBetweenPlayers = 1.5;
    if (minSizeConstraint <= 768) {
      spaceBetweenPlayers = 1.25;
    }
    if (minSizeConstraint <= 576) {
      spaceBetweenPlayers = 1.75;
    }
    final placeForPlayersInCircle =
        playerIconSize *
        players.length *
        MediaQuery.textScalerOf(context).scale(spaceBetweenPlayers);

    if (placeForPlayersInCircle >= circlePerimeter) {
      return PlayersPlacedInGrid();
    }
    return PlayersPlacedInCircle(
      circleDiameter: circleDiameter,
      playerIconSize: playerIconSize,
    );
  }
}
