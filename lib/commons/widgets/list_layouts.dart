import 'package:flutter/material.dart';

import '../utils/screen.dart';

/// A grid which takes all the available space in the layout
class MyGrid extends StatelessWidget {
  /// The function to build each item
  final List<Widget> children;

  const MyGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: ScreenHelper.width * 0.5,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 1.4,
      children: children,
    );
  }
}

/// A list which takes all the available space in the layout
class MyList extends StatelessWidget {
  /// The number of items in the list
  final int itemCount;

  /// The function to build each item
  final Widget Function(BuildContext, int) itemBuilder;

  const MyList({super.key, required this.itemCount, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: (_, __) => const SizedBox(
        height: 24,
      ),
    );
  }
}
