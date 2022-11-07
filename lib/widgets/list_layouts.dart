import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A grid which takes all the available space in the layout
class MyGrid extends GetView {
  /// The height of each element in the grid. Default value is Get.height*0.12
  final double? mainAxisExtent;

  /// The number of items in the grid
  final int itemCount;

  /// The function to build each item
  final Widget Function(BuildContext, int) itemBuilder;

  MyGrid(
      {this.mainAxisExtent,
      required this.itemCount,
      required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 32,
        mainAxisSpacing: 40,
        mainAxisExtent: this.mainAxisExtent == null
            ? Get.height * 0.15
            : this.mainAxisExtent,
      ),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      itemCount: this.itemCount,
      itemBuilder: this.itemBuilder,
    );
  }
}

/// A list which takes all the available space in the layout
class MyList extends GetWidget {
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
