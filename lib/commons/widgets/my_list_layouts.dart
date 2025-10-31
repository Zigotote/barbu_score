import 'package:flutter/material.dart';

/// A grid which takes all the available space in the layout
class MyGrid extends StatelessWidget {
  /// The function to build each item
  final List<Widget> children;

  const MyGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.landscape ? 4 : 2,
        mainAxisExtent: 100 * MediaQuery.of(context).textScaler.scale(1),
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      shrinkWrap: true,
      itemCount: children.length,
      itemBuilder: (_, index) => children[index],
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
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: (_, _) => const SizedBox(height: 24),
    );
  }
}
