import 'dart:ui';

import 'package:barbu_score/commons/utils/storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commons/utils/screen.dart';

final isDarkThemeProvider = StateNotifierProvider<_IsDarkThemeNotifier, bool?>(
    (ref) => _IsDarkThemeNotifier());

class _IsDarkThemeNotifier extends StateNotifier<bool?> {
  _IsDarkThemeNotifier() : super(MyStorage.getIsDarkTheme());

  void changeTheme(bool isDark) {
    state = isDark;
    MyStorage.saveIsDarkTheme(isDark);
  }

  /// Returns the current saved brightness bool or app brightness if nothing is saved
  bool get isDark => state ?? ScreenHelper.brightness == Brightness.dark;
}
