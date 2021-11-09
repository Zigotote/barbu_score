import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// An ElevatedButton with a full width
class ElevatedButtonFullWidth extends GetWidget {
  /// The text of the button
  final String text;

  /// The function to call on pressed action
  final Function() onPressed;

  ElevatedButtonFullWidth({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(this.text),
      onPressed: this.onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(Get.width * 0.9, Get.height * 0.08),
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
          ? Text(
              this.text,
              style: TextStyle(color: this.color),
            )
          : Icon(
              this.icon,
              color: this.color,
            ),
      onPressed: this.onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: this.color, width: 2),
      ),
    );
  }
}
