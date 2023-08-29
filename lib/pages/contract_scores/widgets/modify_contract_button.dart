import 'package:flutter/material.dart';

import '../../../theme/my_themes.dart';

/// A button with a widget in the top right corner
class ModifyContractButton extends StatelessWidget {
  /// The text of the button
  final String text;

  /// The function to call on button pressed action
  final Function()? onPressed;

  const ModifyContractButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: Text(text, textAlign: TextAlign.center),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Icon(
            Icons.task_alt_outlined,
            color: Theme.of(context).colorScheme.success,
          ),
        )
      ],
    );
  }
}
