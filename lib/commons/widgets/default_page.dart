import 'package:flutter/material.dart';

import './my_appbar.dart';

/// A page with a beautiful layout
class DefaultPage extends StatelessWidget {
  /// The title of the page
  final String title;

  /// The tabs of the page
  final List<Tab>? tabs;

  /// The widget for the content of the page
  final Widget content;

  /// The widget to display at the bottom of the page
  final Widget? bottomWidget;

  /// True if the background has to be drawn
  final bool hasBackground;

  /// True if a go back leading should be displayed before the title of the page
  final bool hasLeading;

  const DefaultPage(
      {super.key,
      required this.title,
      this.tabs,
      required this.content,
      this.bottomWidget,
      this.hasBackground = false,
      this.hasLeading = false});

  @override
  Widget build(BuildContext context) {
    Widget page = Scaffold(
      appBar: MyAppBar(
        context,
        tabs: tabs,
        title,
        hasLeading: hasLeading,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: hasBackground
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: content,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: bottomWidget,
      ),
    );
    page = tabs == null
        ? page
        : DefaultTabController(length: tabs!.length, child: page);
    return hasLeading
        ? page
        : WillPopScope(onWillPop: () => Future.value(false), child: page);
  }
}
