import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A widget to display a subtitle in a page
class MySubtitle extends GetWidget {
  /// The text of the subtitle
  final String subtitle;

  MySubtitle(this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Center(
        child: Text(
          this.subtitle,
          style: Get.textTheme.titleSmall,
        ),
      ),
    );
  }
}
