import 'package:flutter/material.dart';

import '../utils/screen.dart';

/// An ElevatedButton with a full width
class ElevatedButtonFullWidth extends StatelessWidget {
  /// The child of the button
  final Widget child;

  /// The function to call on pressed action
  final Function() onPressed;

  const ElevatedButtonFullWidth(
      {super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            ScreenHelper.width - 24,
            ScreenHelper.height * 0.08,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// A button with a custom border and text color
class ElevatedButtonCustomColor extends StatelessWidget {
  /// The text of the button
  final String? text;

  /// The icon of the button
  final IconData? icon;

  /// The color of the button's text and border
  final Color color;

  /// The function to call on button's pressed
  final Function() onPressed;

  /// The size of the text inside the button
  final double textSize;

  /// The background color of the button
  final Color? backgroundColor;

  const ElevatedButtonCustomColor({
    super.key,
    this.text,
    this.icon,
    required this.color,
    required this.onPressed,
    this.textSize = 22,
    this.backgroundColor,
  }) : assert(
            ((text != null || icon != null) && (text == null || icon == null)),
            "You have to provide an icon or a text for the button");

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: color, width: 2),
        padding: const EdgeInsets.all(8),
        foregroundColor: color,
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      ),
      child: text != null
          ? Text(
              text!,
              style: TextStyle(fontSize: textSize),
            )
          : Icon(icon),
    );
  }
}
