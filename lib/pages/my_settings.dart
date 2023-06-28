import 'package:barbu_score/widgets/default_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySettings extends GetView {
  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Paramètres",
      hasLeading: true,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Thème"),
          ElevatedButton(
              onPressed: () => Get.changeThemeMode(ThemeMode.dark),
              child: Text('Sombre')),
          ElevatedButton(
              onPressed: () => Get.changeThemeMode(ThemeMode.light),
              child: Text('Clair'))
        ],
      ),
    );
  }
}
