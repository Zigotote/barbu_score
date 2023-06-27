import 'package:flutter/material.dart';

/// A container with a colored border
class ColoredContainer extends StatelessWidget {
  /// The height of the container
  final double height;

  /// The width of the container, if not specified the width of the parent is used
  final double? width;

  /// The color to use for the border
  final Color color;

  /// The child to put on the container
  final Widget child;

  ColoredContainer({
    required this.height,
    this.width,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: this.color,
          width: 2,
        ),
      ),
      child: this.child,
    );
  }
}
