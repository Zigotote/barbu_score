import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = StateProvider((ref) => AppThemeState());

class AppThemeState extends StateNotifier<bool> {
  AppThemeState() : super(false);

  ThemeData get theme => state ? MyThemes.dark : MyThemes.light;

  void setLightTheme() {
    state = false;
  }

  void setDarkTheme() {
    state = true;
  }
}
