import 'package:barbu_score/utils/screen.dart';
import 'package:flutter/material.dart';

/// A grid which takes all the available space in the layout
class MyGrid extends StatelessWidget {
  /// The function to build each item
  final List<Widget> children;

  MyGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: ScreenHelper.width * 0.5,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 1.4,
      children: this.children,
    );
  }
}

/// A list which takes all the available space in the layout
class MyList extends StatelessWidget {
  /// The number of items in the list
  final int itemCount;

  /// The function to build each item
  final Widget Function(BuildContext, int) itemBuilder;

  MyList({required this.itemCount, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        vertical: 16,
      ),
      shrinkWrap: true,
      itemCount: this.itemCount,
      itemBuilder: this.itemBuilder,
      separatorBuilder: (_, __) => SizedBox(
        height: 24,
      ),
    );
  }
}
