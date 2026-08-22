import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';

import 'alert_dialog.dart';

class ResetButton extends StatelessWidget {
  /// The function to call when reset action is confirmed
  final void Function() onReset;

  const ResetButton({super.key, required this.onReset});

  void _openConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return MyAlertDialog(
          context: context,
          title: context.l10n.resetSettings,
          content: context.l10n.confirmResetSettings,
          actions: [
            AlertDialogActionButton(
              text: context.l10n.refuse,
              onPressed: () => {},
            ),
            AlertDialogActionButton(
              isDestructive: true,
              text: context.l10n.accept,
              onPressed: onReset,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _openConfirmDialog(context),
      icon: Icon(Icons.restore),
      label: Text(
        context.l10n.reset,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
