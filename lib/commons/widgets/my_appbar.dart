import 'package:flutter/material.dart';

import '../../main.dart';
import 'my_tabbar.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHome;
  final bool hasLeading;
  final List<Tab>? tabs;

  const MyAppBar(
    this.title, {
    super.key,
    this.isHome = false,
    this.hasLeading = false,
    this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      centerTitle: true,
      forceMaterialTransparency: true,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: preferredSize.height,
          child: Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      leading: hasLeading
          ? IconButton.outlined(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                try {
                  Navigator.of(context).pop();
                } catch (_) {
                  Navigator.of(context).pushNamed(Routes.home);
                }
              })
          : null,
      title: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: isHome
              ? Theme.of(context).textTheme.displaySmall
              : Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      bottom: tabs == null ? null : MyTabBar(tabs!),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
