import 'package:flutter/material.dart';

/// A layout for a question with an user input field
class SettingQuestion extends StatelessWidget {
  /// The question
  final String label;

  /// The input to save user response
  final Widget input;

  /// A function to call when tapping on the widget
  final Function()? onTap;

  /// The text to detail the label, for more explanation
  final String? tooltip;

  const SettingQuestion({
    super.key,
    required this.label,
    required this.input,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MergeSemantics(
        child: Row(
          spacing: 8,
          children: [
            if (tooltip != null)
              Tooltip(
                message: tooltip,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 3),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.info_outline_rounded),
              ),
            Expanded(child: Text(label)),
            input,
          ],
        ),
      ),
    );
  }
}
