import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import 'custom_buttons.dart';

/// A class to represent properties for a button in an alert dialog
class AlertDialogActionButton {
  /// The text of the action
  final String text;

  /// The function to call on action button pressed
  final Function() onPressed;

  AlertDialogActionButton({required this.text, required this.onPressed});
}

/// A custom alert dialog
class MyAlertDialog extends AlertDialog {
  MyAlertDialog(
      {super.key,
      required BuildContext context,
      required String title,
      required String content,
      required AlertDialogActionButton defaultAction,
      required AlertDialogActionButton destructiveAction})
      : super(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButtonCustomColor(
              color: Theme.of(context).colorScheme.success,
              textSize: 16,
              text: defaultAction.text,
              onPressed: defaultAction.onPressed,
            ),
            ElevatedButtonCustomColor(
              color: Theme.of(context).colorScheme.error,
              textSize: 16,
              text: destructiveAction.text,
              onPressed: destructiveAction.onPressed,
            ),
          ],
        );
}
