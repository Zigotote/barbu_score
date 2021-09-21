import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A grid which takes all the available space in the layout
class MyGrid extends GetWidget {
  /// The number of items in the grid
  final int itemCount;

  /// The function to build each item
  final Function(BuildContext, int) itemBuilder;

  MyGrid({@required this.itemCount, @required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Get.width * 0.1,
        mainAxisSpacing: Get.width * 0.1,
        childAspectRatio: 2,
      ),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.04,
        horizontal: Get.width * 0.02,
      ),
      itemCount: this.itemCount,
      itemBuilder: this.itemBuilder,
    );
  }
}
