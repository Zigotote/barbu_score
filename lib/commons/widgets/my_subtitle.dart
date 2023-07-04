import 'package:flutter/material.dart';

/// A widget to display a subtitle in a page
class MySubtitle extends StatelessWidget {
  /// The text of the subtitle
  final String subtitle;

  const MySubtitle(this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Center(
        child: Text(
          subtitle,
          style: Theme.of(context).textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
