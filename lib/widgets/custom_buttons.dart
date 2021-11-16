import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// An ElevatedButton with a full width
class ElevatedButtonFullWidth extends GetView {
  /// The child of the button
  final Widget child;

  /// The function to call on pressed action
  final Function() onPressed;

  ElevatedButtonFullWidth({@required this.child, @required this.onPressed});

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
  final String text;

  /// The icon of the button
  final IconData icon;

  /// The color of the button
  final Color color;

  /// The function to call on button's pressed
  final Function() onPressed;

  ElevatedButtonCustomColor({
    this.text,
    this.icon,
    @required this.color,
    @required this.onPressed,
  }) : assert(
            ((text != null || icon != null) && (text == null || icon == null)),
            "You have to provide an icon or a text for the button");

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: this.text != null
          ? Text(this.text, textAlign: TextAlign.center)
          : Icon(this.icon),
      onPressed: this.onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: this.color, width: 2),
        onPrimary: this.color,
      ),
    );
  }
}
