import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// An icon for the player
class PlayerIcon extends GetView {
  /// The image of the player
  final String image;

  /// The indicator to know if the player should have a medal
  final bool hasMedal;

  /// The color of the icon
  final Color color;

  /// The size of the icon
  final double size;

  PlayerIcon({
    @required this.image,
    @required this.size,
    this.hasMedal,
    this.color = const Color(0xFFBDBDBD),
  });

  Widget _buildPlayerIcon() {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: this.color,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage(this.image),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.hasMedal == true) {
      return Stack(
        children: [
          _buildPlayerIcon(),
          Container(
            width: this.size,
            height: this.size,
            decoration: BoxDecoration(
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
    return _buildPlayerIcon();
  }
}
