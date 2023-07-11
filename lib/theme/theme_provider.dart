import 'package:barbu_score/commons/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider =
    StateNotifierProvider<AppThemeMode, ThemeMode>((ref) => AppThemeMode());

class AppThemeMode extends StateNotifier<ThemeMode> {
  AppThemeMode() : super(MyStorage().getAppTheme());

  void setLightTheme() {
    state = ThemeMode.light;
    MyStorage().saveAppTheme(state);
  }

  void setDarkTheme() {
    state = ThemeMode.dark;
    MyStorage().saveAppTheme(state);
  }
}
