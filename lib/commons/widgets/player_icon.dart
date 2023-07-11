import 'package:flutter/material.dart';

/// An icon for the player
class PlayerIcon extends StatelessWidget {
  /// The image of the player
  final String image;

  /// The indicator to know if the player should have a medal
  final bool hasMedal;

  /// The color of the icon
  final Color color;

  /// The size of the icon
  final double size;

  const PlayerIcon({
    super.key,
    required this.image,
    required this.size,
    this.hasMedal = false,
    this.color = const Color(0xFFBDBDBD),
  });

  @override
  Widget build(BuildContext context) {
    final CircleAvatar playerIcon = CircleAvatar(
      backgroundColor: color,
      radius: size / 2,
      child: Image.asset(image),
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
