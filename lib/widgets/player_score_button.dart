import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './custom_buttons.dart';
import './player_icon.dart';
import '../controller/player.dart';
import '../main.dart';

/// A button to display the score of a player
class PlayerScoreButton extends GetWidget {
  /// The infos of the player
  final PlayerController player;

  /// The score of the player
  final int score;

  /// The indicator for the winner
  final bool isFirst;

  /// The best friend of the player
  final PlayerController? bestFriend;

  /// The worst ennemy of the player
  final PlayerController? worstEnnemy;

  PlayerScoreButton(
      {required this.player,
      required this.score,
      this.isFirst = false,
      this.bestFriend,
      this.worstEnnemy});

  /// Returns true if the line with the friend and ennemy of the player should be displayed
  bool _showFriendStatus() {
    return bestFriend != null && worstEnnemy != null;
  }

  /// Returns the widget with the friend and the ennemy of the player
  Widget _buildFriendStatus() {
    double badgesSize = Get.width * 0.075;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.sentiment_very_dissatisfied_outlined,
          size: badgesSize,
        ),
        PlayerIcon(
          image: worstEnnemy!.image,
          color: worstEnnemy!.color,
          size: badgesSize,
        ),
        Padding(padding: EdgeInsets.only(left: 16)),
        Icon(
          Icons.sentiment_very_satisfied_outlined,
          size: badgesSize,
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
            hasMedal: isFirst,
            color: player.color,
            size: Get.width * 0.15,
          ),
          Expanded(
            child: Column(
              children: [
                Text(player.name),
                Text("$score points"),
                this._showFriendStatus() ? _buildFriendStatus() : Container(),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
      onPressed: () => Get.toNamed(Routes.SCORES_BY_PLAYER, arguments: player),
    );
  }
}
