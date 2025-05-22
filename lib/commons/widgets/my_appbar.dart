import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import 'my_tabbar.dart';

class MyAppBar extends AppBar {
  /// The tabs to display at the bottom of the appBar
  final List<Tab>? tabs;

  MyAppBar(
    String title, {
    super.key,
    required BuildContext context,
    bool isHome = false,
    bool hasLeading = true,
    IconButton? trailing,
    this.tabs,
  }) : super(
          toolbarHeight: _calculateToolbarHeight(context, title),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          centerTitle: true,
          forceMaterialTransparency: true,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Container(
              alignment: Alignment.center,
              height: _calculateToolbarHeight(context, title),
              child: Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          leading: hasLeading && context.canPop()
              ? IconButton.outlined(
                  tooltip: "Retour",
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      context.pop();
                    } catch (_) {
                      context.push(Routes.home);
                    }
                  })
              : null,
          title: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Semantics(
              header: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: isHome
                    ? Theme.of(context).textTheme.displaySmall
                    : Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          actions: trailing != null ? [trailing] : null,
          bottom: tabs == null ? null : MyTabBar(tabs),
        );

  static double _calculateToolbarHeight(BuildContext context, String title) {
    return (Theme.of(context).textTheme.displaySmall?.fontSize ?? 1) *
        (title.contains("\n") ? 2 : 1);
  }
}
