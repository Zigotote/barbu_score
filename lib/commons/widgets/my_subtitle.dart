import 'package:barbu_score/theme/my_themes.dart';
import 'package:flutter/material.dart';

import '../../theme/my_theme_colors.dart';

/// A widget to display a subtitle in a page
class MySubtitle extends StatelessWidget {
  /// The text of the subtitle
  final String subtitle;

  /// The background color to display behind the title
  final MyThemeColors? backgroundColor;

  const MySubtitle(this.subtitle, {super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColor != null
          ? BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(28.0)),
              color: Theme.of(context).colorScheme.convertMyColor(
                backgroundColor!,
                isBackgroundColor: true,
              ),
            )
          : null,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
