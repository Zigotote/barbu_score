import 'package:flutter/material.dart';

/// The title of a section, with style and semantics
class MySectionTitle extends StatelessWidget {
  /// The title to display
  final String title;

  const MySectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      headingLevel: 2,
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
