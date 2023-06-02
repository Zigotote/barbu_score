import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// An ElevatedButton with a full width
class ElevatedButtonFullWidth extends GetView {
  /// The child of the button
  final Widget child;

  /// The function to call on pressed action
  final Function() onPressed;

  ElevatedButtonFullWidth({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        child: this.child,
        onPressed: this.onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(Get.width - 24, Get.height * 0.08),
        ),
      ),
    );
  }
}

/// A button with a custom border and text color
class ElevatedButtonCustomColor extends GetView {
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

  ElevatedButtonCustomColor({
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
      child: this.text != null
          ? Text(
              this.text!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: this.textSize),
            )
          : Icon(this.icon),
      onPressed: this.onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: this.color, width: 2),
        padding: EdgeInsets.all(8),
        foregroundColor: this.color,
        backgroundColor: backgroundColor ?? Get.theme.scaffoldBackgroundColor,
      ),
    );
  }
}

/// A button with an widget in the top right corner
class ElevatedButtonTopRightWidget extends GetView {
  /// The text of the button
  final String text;

  /// The function to call on button pressed action
  final Function()? onPressed;

  /// The widget to display in the top right corner
  final Widget topRightChild;

  ElevatedButtonTopRightWidget({
    required this.text,
    required this.topRightChild,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        ElevatedButton(
          child: Text(this.text),
          onPressed: this.onPressed,
        ),
        Positioned(
          right: 8,
          top: 8,
          child: this.topRightChild,
        )
      ],
    );
  }
}

/// An outlinedButton without border
class OutlinedButtonNoBorder extends GetView {
  /// The content of the button
  final Widget child;

  /// The function to call on button pressed action
  final Function()? onPressed;

  /// The color of the button background
  final Color? backgroundColor;

  OutlinedButtonNoBorder(
      {required this.child, this.onPressed, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: child,
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.zero,
        side: BorderSide.none,
      ),
    );
  }
}
