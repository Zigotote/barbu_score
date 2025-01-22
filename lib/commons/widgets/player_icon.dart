import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import '../models/player_colors.dart';

/// An icon for the player
class PlayerIcon extends StatelessWidget {
  /// The image of the player
  final String image;

  /// The indicator to know if the player should have a medal
  final bool hasMedal;

  /// The color of the icon
  final PlayerColors? color;

  /// The size of the icon
  final double size;

  const PlayerIcon({
    super.key,
    required this.image,
    this.size = 90,
    this.hasMedal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).colorScheme.grey;
    if (color != null) {
      backgroundColor =
          Theme.of(context).colorScheme.convertPlayerColor(color!);
    }
    final CircleAvatar playerIcon = CircleAvatar(
      backgroundColor: backgroundColor,
      radius: size / 2,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage(image),
          ),
        ),
      ),
    );
    if (hasMedal) {
      return Stack(
        children: [
          playerIcon,
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage("assets/medal.png"),
              ),
            ),
          ),
        ],
      );
    }
    return playerIcon;
  }
}
