import 'package:flutter/material.dart';

class SnackBarUtils {
  /// Indicates if a snackbar is currently open
  bool _isSnackBarOpen;

  SnackBarUtils._() : _isSnackBarOpen = false;

  static final SnackBarUtils _instance = SnackBarUtils._();

  static SnackBarUtils instance = _instance;

  void openSnackBar(
      {required BuildContext context,
      required String title,
      required String text}) {
    if (!_instance._isSnackBarOpen) {
      _instance._isSnackBarOpen = true;
      final TextTheme textTheme = Theme.of(context).textTheme;
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(text, style: textTheme.bodyLarge),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
              dismissDirection: DismissDirection.horizontal,
            ),
          )
          .closed
          .then((_) => _instance._isSnackBarOpen = false);
    }
  }

  void closeSnackBar(BuildContext context) {
    if (_instance._isSnackBarOpen) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
  }
}
