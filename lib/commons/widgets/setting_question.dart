import 'package:barbu_score/theme/my_themes.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Semantics(hint: tooltip, child: Text(label)),
                  input,
                ],
              ),
            ),
            if (tooltip != null)
              ExcludeSemantics(
                child: Text(
                  tooltip!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onGreyBackground,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
