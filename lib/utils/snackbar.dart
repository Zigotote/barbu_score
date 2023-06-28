import 'package:flutter/material.dart';

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
              content: Row(
                children: [
                  Text(title, style: textTheme.bodyLarge),
                  Text(text),
                ],
              ),
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
