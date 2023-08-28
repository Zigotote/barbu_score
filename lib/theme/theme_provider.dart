import 'package:barbu_score/commons/utils/storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkThemeProvider = StateNotifierProvider<_IsDarkThemeNotifier, bool>(
    (ref) => _IsDarkThemeNotifier());

class _IsDarkThemeNotifier extends StateNotifier<bool> {
  _IsDarkThemeNotifier() : super(MyStorage.getIsDarkTheme());

  void changeTheme(bool isDark) {
    state = isDark;
    MyStorage.saveIsDarkTheme(isDark);
  }
}
