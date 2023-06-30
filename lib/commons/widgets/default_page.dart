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

  DefaultPage(
      {required this.title,
      this.tabs,
      required this.content,
      this.bottomWidget,
      this.hasBackground = false,
      this.hasLeading = false});

  @override
  Widget build(BuildContext context) {
    Widget page = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        context,
        tabs: tabs,
        this.title,
        hasLeading: this.hasLeading,
      ),
      body: Container(
        decoration: this.hasBackground
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              )
            : null,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: this.content,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: this.bottomWidget,
      ),
    );
    page = this.tabs == null
        ? page
        : DefaultTabController(length: tabs!.length, child: page);
    return this.hasLeading
        ? page
        : WillPopScope(onWillPop: () async => false, child: page);
  }
}
