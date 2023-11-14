import 'package:flutter/material.dart';

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
          minimumSize: const Size.fromHeight(48),
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

/// A button with an indicator on top
class ElevatedButtonWithIndicator extends StatelessWidget {
  /// The text of the button
  final String text;

  /// The function to call on button's pressed
  final Function() onPressed;

  /// The indicator to display on top off the button
  final Widget indicator;

  const ElevatedButtonWithIndicator(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.indicator});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: Text(text, textAlign: TextAlign.center),
        ),
        Positioned(right: 8, top: 8, child: indicator)
      ],
    );
  }
}
