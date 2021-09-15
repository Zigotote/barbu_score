import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// An ElevatedButton with a full width
class ElevatedButtonFullWidth extends GetWidget {
  /// The text of the button
  final String text;

  /// The function to call on pressed action
  final Function onPressed;

  ElevatedButtonFullWidth({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Text(this.text),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(Get.width * 0.9, Get.height * 0.08),
        ),
      ),
    );
  }
}
