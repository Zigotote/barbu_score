import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// An icon for the player
class PlayerIcon extends GetWidget {
  /// The image of the player
  final String image;

  /// The color of the icon
  final Color color;

  /// The size of the icon
  final double size;

  PlayerIcon({
    @required this.image,
    @required this.size,
    this.color = const Color(0xFFBDBDBD),
  });

  @override
  Widget build(BuildContext context) {
    print(this.color);
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
}
