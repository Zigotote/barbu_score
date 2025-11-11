import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import '../../theme/my_theme_colors.dart';

/// An ElevatedButton with a full width
class ElevatedButtonFullWidth extends ElevatedButton {
  ElevatedButtonFullWidth({
    super.key,
    required super.child,
    required super.onPressed,
  }) : super(
         style: ElevatedButton.styleFrom(
           minimumSize: const Size.fromHeight(48),
         ),
       );
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
  final MyThemeColors? colorFromPlayer;

  /// The function to call on button's pressed
  final Function() onPressed;

  /// The size of the text inside the button
  final double? textSize;

  /// The background color of the button
  final Color? background;

  /// The background color of the button, defined by player color
  final MyThemeColors? backgroundFromPlayer;

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
  }) : assert(
         color == null || colorFromPlayer == null,
         "Color should be fixed or come from player",
       ),
       assert(
         background == null || backgroundFromPlayer == null,
         "Background should be fixed or come from player",
       );

  factory ElevatedButtonCustomColor({
    Key? key,
    String? text,
    IconData? icon,
    required Color color,
    required Function() onPressed,
    double? textSize,
    Color? backgroundColor,
    String? semantics,
  }) => ElevatedButtonCustomColor._(
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
    MyThemeColors? color,
    required Function() onPressed,
    double? textSize,
    MyThemeColors? backgroundColor,
    String? semantics,
  }) => ElevatedButtonCustomColor._(
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
      foregroundColor = Theme.of(
        context,
      ).colorScheme.convertMyColor(colorFromPlayer!);
    }
    var backgroundColor = background ?? defaultColor;
    if (backgroundFromPlayer != null) {
      backgroundColor = Theme.of(
        context,
      ).colorScheme.convertMyColor(backgroundFromPlayer!);
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
        : MergeSemantics(
            child: Semantics(label: semantics, child: button),
          );
  }
}

/// A button with an indicator on top
class ElevatedButtonWithIndicator extends StatelessWidget {
  /// The text of the button
  final String text;

  /// The function to call on button's pressed
  final Function() onPressed;

  /// The indicator to display on top off the button. Optional so that in a list with and with indicators, all the buttons have the same size
  final Widget? indicator;

  /// The color of border and text for the button (follows theme's color by default)
  final MyThemeColors? color;

  const ElevatedButtonWithIndicator({
    super.key,
    required this.text,
    required this.onPressed,
    required this.indicator,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle? buttonStyle;
    if (color != null) {
      final themeColor = Theme.of(context).colorScheme.convertMyColor(color!);
      buttonStyle = ElevatedButton.styleFrom(
        side: BorderSide(color: themeColor, width: 2),
        foregroundColor: themeColor,
        iconColor: themeColor,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: MergeSemantics(
        child: GestureDetector(
          onTap: onPressed,
          child: Stack(
            alignment: AlignmentDirectional.center,
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              ElevatedButton(
                onPressed: onPressed,
                style: buttonStyle,
                child: Text(text, textAlign: TextAlign.center),
              ),
              if (indicator != null)
                Positioned(right: -8, bottom: -8, child: indicator!),
            ],
          ),
        ),
      ),
    );
  }
}
