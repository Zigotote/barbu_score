import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;

  MyTabBar(List<Tab> tabs, {super.key}) : tabBar = TabBar(tabs: tabs);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: 2,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        tabBar,
      ],
    );
  }

  @override
  Size get preferredSize => tabBar.preferredSize;
}
