import 'package:flutter/material.dart';

import 'screen.dart';

class SnackbarUtils {
  /// Indicates if a snackbar is currently open
  bool _isSnackBarOpen;

  SnackbarUtils._() : _isSnackBarOpen = false;

  static final SnackbarUtils _instance = SnackbarUtils._();

  static SnackbarUtils instance = _instance;

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
              margin: EdgeInsets.only(
                bottom: ScreenHelper.height - 200,
                right: 8,
                left: 8,
              ),
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
