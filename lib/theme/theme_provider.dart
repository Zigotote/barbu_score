import 'package:barbu_score/commons/providers/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkThemeProvider =
    NotifierProvider<_IsDarkThemeNotifier, bool>(_IsDarkThemeNotifier.new);

class _IsDarkThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return ref.read(storageProvider).getIsDarkTheme() ??
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
  }

  void changeTheme(bool isDark) {
    state = isDark;
    ref.read(storageProvider).saveIsDarkTheme(isDark);
  }
}
