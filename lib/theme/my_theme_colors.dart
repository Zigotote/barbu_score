import 'package:flutter/material.dart';

/// The colors available for the app
enum MyThemeColors {
  brown(light: Color(0xFF5D4037), dark: Color(0xFF9E8179)),
  green(light: Color(0xFF33691E), dark: Color(0xFF2D9C09)),
  yellow(light: Color(0xFFF9A825), dark: Color(0xFFF9A825)),
  orange(light: Color(0xFFEF6C00), dark: Color(0xFFEF6C00)),
  red(light: Color(0xFFBF360C), dark: Color(0xFFFE3C14)),
  blueGreen(light: Color(0xFF004D40), dark: Color(0xFF029980)),
  darkPurple(light: Color(0xFF42004D), dark: Color(0xFFD062E9)),
  darkBlue(light: Color(0xFF00164D), dark: Color(0xFFB2C8FF)),
  blue(light: Color(0xFF0060EF), dark: Color(0xFF1E86FC)),
  purple(light: Color(0xFF7800EF), dark: Color(0xFFA567F6)),
  deepRed(light: Color(0xFFA80051), dark: Color(0xFFFF57A8));

  final Color light;
  final Color dark;

  const MyThemeColors({required this.light, required this.dark});

  /// Returns the PlayerColors from its name
  static MyThemeColors fromName(String name) {
    return MyThemeColors.values.firstWhere((color) => color.name == name);
  }
}
