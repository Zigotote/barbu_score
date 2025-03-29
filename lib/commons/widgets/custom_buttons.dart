import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import '../models/player_colors.dart';

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
  final Color? color;

  /// The color of the button's text and border, defined by player color
  final PlayerColors? colorFromPlayer;

  /// The function to call on button's pressed
  final Function() onPressed;

  /// The size of the text inside the button
  final double? textSize;

  /// The background color of the button
  final Color? background;

  /// The background color of the button, defined by player color
  final PlayerColors? backgroundFromPlayer;

  /// The semantics of the button, if its label is not sufficient enough
  final String? semantics;

  const ElevatedButtonCustomColor._({
    super.key,
    this.text,
    this.icon,
    this.color,
    this.colorFromPlayer,
    required this.onPressed,
    this.textSize,
    this.background,
    this.backgroundFromPlayer,
    this.semantics,
  })  : assert(color == null || colorFromPlayer == null,
            "Color should be fixed or come from player"),
        assert(background == null || backgroundFromPlayer == null,
            "Background should be fixed or come from player");

  factory ElevatedButtonCustomColor({
    Key? key,
    String? text,
    IconData? icon,
    required Color color,
    required Function() onPressed,
    double? textSize,
    Color? backgroundColor,
    String? semantics,
  }) =>
      ElevatedButtonCustomColor._(
        key: key,
        text: text,
        icon: icon,
        color: color,
        onPressed: onPressed,
        textSize: textSize,
        background: backgroundColor,
        semantics: semantics,
      );

  factory ElevatedButtonCustomColor.player({
    Key? key,
    String? text,
    IconData? icon,
    PlayerColors? color,
    required Function() onPressed,
    double? textSize,
    PlayerColors? backgroundColor,
    String? semantics,
  }) =>
      ElevatedButtonCustomColor._(
        key: key,
        text: text,
        icon: icon,
        colorFromPlayer: color,
        onPressed: onPressed,
        textSize: textSize,
        backgroundFromPlayer: backgroundColor,
        semantics: semantics,
      );

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).scaffoldBackgroundColor;
    var foregroundColor = color ?? defaultColor;
    if (colorFromPlayer != null) {
      foregroundColor =
          Theme.of(context).colorScheme.convertPlayerColor(colorFromPlayer!);
    }
    var backgroundColor = background ?? defaultColor;
    if (backgroundFromPlayer != null) {
      backgroundColor = Theme.of(context)
          .colorScheme
          .convertPlayerColor(backgroundFromPlayer!);
    }
    final style = ElevatedButton.styleFrom(
      side: BorderSide(color: foregroundColor, width: 2),
      padding: const EdgeInsets.all(8),
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      iconColor: foregroundColor,
    );
    final button = icon != null && text != null
        ? ElevatedButton.icon(
            style: style,
            onPressed: onPressed,
            label: Text(text!, textAlign: TextAlign.center),
            icon: Icon(icon),
          )
        : ElevatedButton(
            style: style,
            onPressed: onPressed,
            child: text != null
                ? Text(
                    text!,
                    style: TextStyle(fontSize: textSize),
                    textAlign: TextAlign.center,
                  )
                : Icon(icon),
          );
    return semantics == null
        ? button
        : MergeSemantics(child: Semantics(label: semantics, child: button));
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            ElevatedButton(
              onPressed: onPressed,
              child: Text(text, textAlign: TextAlign.center),
            ),
            Positioned(
              right: -8,
              bottom: -8,
              child: Container(
                padding: const EdgeInsets.only(top: 4, left: 4),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: indicator,
              ),
            )
          ],
        ),
      ),
    );
  }
}
