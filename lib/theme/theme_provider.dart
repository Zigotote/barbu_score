import 'package:barbu_score/commons/notifiers/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkThemeProvider = StateNotifierProvider<_IsDarkThemeNotifier, bool?>(
  (ref) {
    final storage = ref.read(storageProvider);
    return _IsDarkThemeNotifier(
      storage.getIsDarkTheme(),
      saveChanges: storage.saveIsDarkTheme,
    );
  },
);

class _IsDarkThemeNotifier extends StateNotifier<bool?> {
  final Function(bool) saveChanges;

  _IsDarkThemeNotifier(super._state, {required this.saveChanges});

  void changeTheme(bool isDark) {
    state = isDark;
    saveChanges(isDark);
  }

  /// Returns true if dark theme is set or system theme is dark. False otherwise
  bool isDarkTheme() {
    return state ??
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
  }
}
