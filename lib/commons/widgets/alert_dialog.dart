import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'custom_buttons.dart';

/// A class to represent properties for a button in an alert dialog
class AlertDialogActionButton {
  /// The text of the action
  final String text;

  /// The function to call on action button pressed
  final Function()? onPressed;

  /// The indicator to know if this action can lead to destructive action
  final bool isDestructive;

  AlertDialogActionButton({
    required this.text,
    this.onPressed,
    this.isDestructive = false,
  });
}

/// A custom alert dialog
class MyAlertDialog extends AlertDialog {
  MyAlertDialog({
    super.key,
    required BuildContext context,
    required String title,
    required String content,
    required List<AlertDialogActionButton> actions,
    bool closeOnAction = true,
  }) : super(
         title: Text(title),
         content: Text(content),
         actionsOverflowButtonSpacing: 8,
         actions: actions
             .map(
               (action) => ElevatedButtonCustomColor(
                 color: action.isDestructive
                     ? Theme.of(context).colorScheme.error
                     : Theme.of(context).colorScheme.success,
                 textSize: 16,
                 text: action.text,
                 onPressed: closeOnAction
                     ? () {
                         context.pop();
                         action.onPressed?.call();
                       }
                     : action.onPressed ?? () {},
               ),
             )
             .toList(),
         scrollable: true,
       );
}
