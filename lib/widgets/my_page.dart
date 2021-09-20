import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_buttons.dart';
import 'my_appbar.dart';

/// A page with a beautiful layout
class MyPage extends GetWidget {
  /// The title of the page
  final String title;

  /// The widget for the content of the page
  final Widget content;

  /// The button to display at the bottom of the page
  final ElevatedButtonFullWidth buttomNavigationButton;

  /// True if the background has to be drawn
  final bool hasBackground;

  MyPage(
      {@required this.title,
      @required this.content,
      @required this.buttomNavigationButton,
      this.hasBackground = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(this.title),
      body: Container(
        decoration: this.hasBackground
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              )
            : null,
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.015,
        ),
        child: this.content,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.015,
        ),
        child: this.buttomNavigationButton,
      ),
    );
  }
}
