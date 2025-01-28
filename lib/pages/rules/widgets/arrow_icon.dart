import 'package:flutter/material.dart';

/// The widget to display forward and backward arrow, on the right color depending on app theme
class ArrowIcon extends StatelessWidget {
  /// The indicator to know if arrow is forward or backward
  final bool isForward;

  const ArrowIcon({super.key, required this.isForward});

  @override
  Widget build(BuildContext context) {
    final path =
        "assets/icons/${Theme.of(context).brightness == Brightness.dark ? "dark" : "light"}";
    final imageName = "arrow_${isForward ? "forward" : "backward"}.png";
    return Image.asset(
      "$path/$imageName",
      height: 40,
      excludeFromSemantics: true,
    );
  }
}
