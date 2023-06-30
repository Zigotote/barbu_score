import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A widget to display a subtitle in a page
class MySubtitle extends GetWidget {
  /// The text of the subtitle
  final String subtitle;

  const MySubtitle(this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Center(
        child: Text(
          subtitle,
          style: Get.textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
