import 'package:flutter/material.dart';

import './my_appbar.dart';
import 'lines_background.dart';

/// A page with a beautiful layout
class DefaultPage extends StatelessWidget {
  /// The padding applied around all the pages in the app
  static const appPadding = EdgeInsets.all(16);

  /// The appbar of the page
  final MyAppBar appBar;

  /// The widget for the content of the page (should be of type sliver)
  final Widget content;

  /// The widget to display at the bottom of the page
  final Widget? bottomWidget;

  /// True if the background has to be drawn
  final bool hasBackground;

  /// True if padding has to be applied by default in the page. If not, page is expected to use [appPadding] internally
  final bool hasPadding;

  const DefaultPage({
    super.key,
    required this.appBar,
    required this.content,
    this.bottomWidget,
    this.hasBackground = false,
    this.hasPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget page = Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Stack(
          children: [
            if (hasBackground) LinesBackground(),
            Container(padding: hasPadding ? appPadding : null, child: content),
          ],
        ),
      ),
      bottomNavigationBar: bottomWidget != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: bottomWidget,
              ),
            )
          : null,
    );
    return appBar.tabs == null
        ? page
        : DefaultTabController(length: appBar.tabs!.length, child: page);
  }
}
