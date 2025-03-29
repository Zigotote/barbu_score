import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../models/player.dart';
import '../utils/router_extension.dart';
import 'custom_buttons.dart';
import 'player_icon.dart';

/// A button to display the score of a player
class PlayerScoreButton extends StatelessWidget {
  /// The infos of the player
  final Player player;

  /// The score of the player
  final int score;

  /// The indicator for the winner
  final bool displayMedal;

  /// The best friend of the player
  final Player? bestFriend;

  /// The worst ennemy of the player
  final Player? worstEnnemy;

  const PlayerScoreButton(
      {super.key,
      required this.player,
      required this.score,
      this.displayMedal = false,
      this.bestFriend,
      this.worstEnnemy});

  /// Returns true if the line with the friend and ennemy of the player should be displayed
  bool _showFriendStatus() {
    return bestFriend != null && worstEnnemy != null;
  }

  /// Returns the widget with the friend and the ennemy of the player
  Widget _buildFriendStatus(BuildContext context) {
    const double badgesSize = 27;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.heart_broken_outlined,
          size: badgesSize,
          semanticLabel: context.l10n.worstEnnemy,
        ),
        PlayerIcon(
          image: worstEnnemy!.image,
          color: worstEnnemy!.color,
          size: badgesSize,
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.favorite_outline,
          size: badgesSize,
          semanticLabel: context.l10n.bestFriend,
        ),
        PlayerIcon(
          image: bestFriend!.image,
          color: bestFriend!.color,
          size: badgesSize,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonFullWidth(
      child: Row(
        children: [
          PlayerIcon(
            image: player.image,
            hasMedal: displayMedal,
            color: player.color,
            size: 55,
          ),
          Expanded(
            child: Column(
              children: [
                Text(player.name, textAlign: TextAlign.center),
                Text("$score ${context.l10n.points}"),
                if (_showFriendStatus()) _buildFriendStatus(context),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
      onPressed: () => context.pushNamed(
        Routes.scoresByPlayer,
        queryParameters: {MyGoRouterState.playerParameter: player.name},
      ),
    );
  }
}
