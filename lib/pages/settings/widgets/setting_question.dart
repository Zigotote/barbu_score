import 'package:flutter/material.dart';

/// A layout for a question with an user input field
class SettingQuestion extends StatelessWidget {
  /// The question
  final String label;

  /// The input to save user response
  final Widget input;

  /// The text to detail the label, for more explanation
  final String? tooltip;

  const SettingQuestion(
      {super.key, required this.label, required this.input, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (tooltip != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Tooltip(
              message: tooltip,
              triggerMode: TooltipTriggerMode.tap,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.info_outline_rounded),
            ),
          ),
        Expanded(child: Text(label)),
        input
      ],
    );
  }
}
