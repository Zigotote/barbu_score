import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/utils/storage.dart';

final isDarkThemeProvider = StateNotifierProvider<_IsDarkThemeNotifier, bool?>(
  (ref) => _IsDarkThemeNotifier(ref.watch(storageProvider).getIsDarkTheme()),
);

class _IsDarkThemeNotifier extends StateNotifier<bool?> {
  _IsDarkThemeNotifier(super._state);

  void changeTheme(bool isDark) {
    state = isDark;
    MyStorage.saveIsDarkTheme(isDark);
  }

  /// Returns true if dark theme is set or system theme is dark. False otherwise
  bool isDarkTheme() {
    return state ??
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
  }
}
