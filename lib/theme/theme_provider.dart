import 'package:barbu_score/commons/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkThemeProvider = StateNotifierProvider<_IsDarkThemeNotifier, bool>(
    (ref) => _IsDarkThemeNotifier());

class _IsDarkThemeNotifier extends StateNotifier<bool> {
  _IsDarkThemeNotifier() : super(MyStorage.getIsDarkTheme());

  void changeTheme(bool isDark) {
    state = isDark;
    MyStorage.saveIsDarkTheme(isDark);
  }

  /// Returns players colors, depending on state
  get playerColors => state
      ? [
          Colors.brown.shade400,
          Colors.lightGreen.shade800,
          Colors.yellow.shade700,
          Colors.orange.shade800,
          Colors.deepOrange.shade700,
          Colors.teal.shade400
        ]
      : [
          Colors.brown.shade700,
          Colors.lightGreen.shade900,
          Colors.yellow.shade800,
          Colors.orange.shade800,
          Colors.deepOrange.shade900,
          Colors.teal.shade900,
        ];
}
