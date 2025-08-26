import 'package:flutter/material.dart';

import './my_appbar.dart';

/// A page with a beautiful layout
class DefaultPage extends StatelessWidget {
  /// The appbar of the page
  final MyAppBar appBar;

  /// The widget for the content of the page
  final Widget content;

  /// The widget to display at the bottom of the page
  final Widget? bottomWidget;

  /// True if the background has to be drawn
  final bool hasBackground;

  const DefaultPage({
    super.key,
    required this.appBar,
    required this.content,
    this.bottomWidget,
    this.hasBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget page = Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: hasBackground
              ? BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage("assets/background.png"),
                    fit: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? BoxFit.fill
                        : BoxFit.fitWidth,
                    alignment: Alignment.bottomCenter,
                  ),
                )
              : null,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: content,
        ),
      ),
      bottomNavigationBar: bottomWidget != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
